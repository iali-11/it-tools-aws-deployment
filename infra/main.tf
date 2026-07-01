module "vpc" {
  source                      = "./modules/vpc"
  default_cidr_block          = var.default_cidr_block
  vpc_cidr_block              = var.vpc_cidr_block
  public_subnet_1_cidr_block  = var.public_subnet_1_cidr_block
  public_subnet_2_cidr_block  = var.public_subnet_2_cidr_block
  private_subnet_1_cidr_block = var.private_subnet_1_cidr_block
  private_subnet_2_cidr_block = var.private_subnet_2_cidr_block
  availability_zone_1         = var.availability_zone_1
  availability_zone_2         = var.availability_zone_2
}

module "alb" {
  source              = "./modules/alb"
  vpc_id              = module.vpc.vpc_id
  public_subnets_ids  = module.vpc.public_subnets_ids
  private_subnets_ids = module.vpc.private_subnets_ids
  default_cidr_block  = var.default_cidr_block
  app_port            = var.app_port
  acm_cert_arn        = module.acm.acm_cert_arn
}

module "ecs" {
  source                             = "./modules/ecs"
  vpc_id                             = module.vpc.vpc_id
  private_subnets_ids                = module.vpc.private_subnets_ids
  it_tools_alb                      = module.alb.it_tools_alb
  it_tools_alb_sg                   = module.alb.it_tools_alb_sg
  ip_it_tools_tg_arn                = module.alb.ip_it_tools_tg_arn
  container_name                     = var.container_name
  cpu                                = var.cpu
  memory                             = var.memory
  ecs_task_execution_role_policy_arn = var.ecs_task_execution_role_policy_arn
  aws_region                         = var.aws_region
  default_cidr_block                 = var.default_cidr_block
  ecr_repository_url                 = var.ecr_repository_url
  app_port                           = var.app_port
  image_tag                          = var.image_tag
}

module "acm" {
  source                     = "./modules/acm"
  it_tools_alb              = module.alb.it_tools_alb
  it_tools_alb_dns_name     = module.alb.it_tools_alb_dns_name
  it_tools_alb_zone_id      = module.alb.it_tools_alb_zone_id
  it_tools_domain_name_root = var.it_tools_domain_name_root
  it_tools_domain_name_www  = var.it_tools_domain_name_www
}