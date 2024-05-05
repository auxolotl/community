import subprocess
import json
import pydiscourse
import os

sigs_eval_result = subprocess.run(["nix", "eval", "-f", "memberships.nix", "--json"], capture_output=True, text=True)
sigs = json.loads(sigs_eval_result.stdout)

forum_base_url = os.environ["DISCOURSE_URL"]
forum_api_username = os.environ["DISCOURSE_API_USER"]
forum_api_key = os.environ["DISCOURSE_API_KEY"]

def extract_accounts(account_type, leaders, members):
    leader_forum_accounts = set()
    member_forum_accounts = set()

    for user in leaders:
        if account_type not in user:
            continue
        
        leader_forum_accounts.add(user[account_type])
        member_forum_accounts.add(user[account_type])

    for user in members:
        if account_type not in user:
            continue

        member_forum_accounts.add(user[account_type])

    return { "leaders": leader_forum_accounts, "members": member_forum_accounts }

def reconcile_forum_accounts():
    forum_client = pydiscourse.DiscourseClient(api_key=forum_api_key, host=forum_base_url, api_username=forum_api_username)

    for sig in sigs:
        group_name = sig["sig"]["forum"]["name"]
        group_id = forum_client.group(group_name)["group"]["id"]

        should_be = extract_accounts("forum", sig["leaders"], sig["members"])
        is_in = {
            "members": set(map(lambda user: user["username"], forum_client.group_members(group_name))),
            "leaders": set(map(lambda user: user["username"], forum_client.group_owners(group_name)))
        }

        to_remove_members = is_in["members"] - should_be["members"]
        to_remove_leaders = is_in["leaders"] - should_be["leaders"] - to_remove_members
        # No need to explicitly remove leadership if they are no longer in the group

        to_add_leaders = should_be["leaders"] - is_in["leaders"]
        to_add_members = should_be["members"] - is_in["members"] - to_add_leaders
        # No need to explicitly add membership if they are being added as a leader

        print(to_remove_members, to_remove_leaders, to_add_members, to_add_leaders)

        if to_remove_members:
            forum_client.delete_group_member(group_id, ",".join(to_remove_members))

        if to_remove_leaders:
            to_remove_leader_ids = []

            for leader in to_remove_leaders:
                to_remove_leader_ids.append(str(forum_client.user(leader)["id"]))

            forum_client.delete_group_owner(group_id, ",".join(to_remove_leader_ids))

        if to_add_members:
            forum_client.add_group_members(group_id, to_add_members)

        if to_add_leaders:
            forum_client.add_group_owners(group_id, to_add_leaders)

reconcile_forum_accounts()
