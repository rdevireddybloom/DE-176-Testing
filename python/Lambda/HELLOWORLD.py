import json

print("Loading function for CI CD deployment")


def lambda_handler(event, context):
    # print("Received event: " + json.dumps(event, indent=2))

    print("edit_Ram2.py")
    print("Nice, the code is deployed")
    print("Nice, the code is deployed as lambda function")
    return 200  # Echo back the first key value
    # raise Exception('Something went wrong')
