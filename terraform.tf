terraform{
    required_providers {
        aws = {
            source = "hashicorp/aws"
            version = "5.91.0"
        }
    tls = {
      source  = "hashicorp/tls"
      version = "~> 4.0"
    }

    local = {
      source  = "hashicorp/local"
      version = "~> 2.0"
    }
    }
}

# Execution plan was stored in plan.out

# terrform fmt reformats configuration to canonical format and style
