from hashlib import sha256

def get_sha256(unencoded: str) -> str:
    return(sha256(unencoded.encode()).hexdigest()) 

def main():
    unencodedString = input("Enter unencoded string: ")
    encodedString = get_sha256(unencodedString)
    print(encodedString)

if __name__ == "__main__":
    main()
