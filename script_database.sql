set FOREIGN_KEY_CHECKS = 0 ;

CREATE TABLE IF NOT EXISTS `usuario` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `email` VARCHAR(45) NULL,
  `senha` text NULL,
  `tipo_cadastro` ENUM('FACEBOOK', 'GOOGLE', 'APP') not null,
  `ios_token` TEXT NULL,
  `android_token` TEXT NULL,
  `refresh_token` TEXT NULL,
  img_avatar text null,
  PRIMARY KEY (`id`))
ENGINE = InnoDB;

CREATE TABLE IF NOT EXISTS `categorias_fornecedor` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `nome_categoria` VARCHAR(45) NULL,
  `tipo_categoria` char(1) default 'P',
  PRIMARY KEY (`id`))
ENGINE = InnoDB;

CREATE TABLE IF NOT EXISTS `fornecedor` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `nome` VARCHAR(200) NULL,
  `logo` TEXT NULL,
  `imagem` TEXT NULL,
  `endereco` VARCHAR(100) NULL,
  `telefone` VARCHAR(45) NULL,
  `latlng` POINT NULL,
  `categorias_fornecedor_id` INT NOT NULL,
  PRIMARY KEY (`id`),
  INDEX `fk_fornecedor_categorias_fornecedor1_idx` (`categorias_fornecedor_id` ASC),
  CONSTRAINT `fk_fornecedor_categorias_fornecedor1`
    FOREIGN KEY (`categorias_fornecedor_id`)
    REFERENCES `categorias_fornecedor` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

CREATE TABLE IF NOT EXISTS `usuario` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `email` VARCHAR(45) NULL DEFAULT NULL,
  `senha` TEXT NULL DEFAULT NULL,
  `tipo_cadastro` ENUM('FACEBOOK', 'GOOGLE', 'APP') NOT NULL,
  `ios_token` TEXT NULL DEFAULT NULL,
  `android_token` TEXT NULL DEFAULT NULL,
  `refresh_token` TEXT NULL DEFAULT NULL,
  `img_avatar` TEXT NULL DEFAULT NULL,
  `fornecedor_id` INT NULL,
  PRIMARY KEY (`id`),
  INDEX `fk_usuario_fornecedor_idx` (`fornecedor_id` ASC),
  CONSTRAINT `fk_usuario_fornecedor`
    FOREIGN KEY (`fornecedor_id`)
    REFERENCES `fornecedor` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


CREATE TABLE IF NOT EXISTS `fornecedor_servicos` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `fornecedor_id` INT NOT NULL,
  `nome_servico` VARCHAR(200) NULL,
  `valor_servico` DECIMAL(10,2) NULL,
  PRIMARY KEY (`id`),
  INDEX `fk_fornecedor_servicos_fornecedor1_idx` (`fornecedor_id` ASC),
  CONSTRAINT `fk_fornecedor_servicos_fornecedor1`
    FOREIGN KEY (`fornecedor_id`)
    REFERENCES `fornecedor` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


CREATE TABLE IF NOT EXISTS `agendamento` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `data_agendamento` DATETIME NULL,
  `usuario_id` INT NOT NULL,
  `fornecedor_id` INT NOT NULL,
  `status` CHAR(2) NOT NULL DEFAULT 'P' COMMENT 'P=Pendente\nCN=Confirmada\nF=Finalizado\nC=Cancelado',
  nome varchar(200) null,
	nome_pet varchar(200) null,
  PRIMARY KEY (`id`),
  INDEX `fk_solicitacao_usuario1_idx` (`usuario_id` ASC),
  INDEX `fk_solicitacao_fornecedor1_idx` (`fornecedor_id` ASC),
  CONSTRAINT `fk_solicitacao_usuario1`
    FOREIGN KEY (`usuario_id`)
    REFERENCES `usuario` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_solicitacao_fornecedor1`
    FOREIGN KEY (`fornecedor_id`)
    REFERENCES `fornecedor` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

CREATE TABLE IF NOT EXISTS `agendamento_servicos` (
  `agendamento_id` INT NOT NULL,
  `fornecedor_servicos_id` INT NOT NULL,
  INDEX `fk_agenda_servicos_agendamento1_idx` (`agendamento_id` ASC),
  INDEX `fk_agenda_servicos_fornecedor_servicos1_idx` (`fornecedor_servicos_id` ASC),
  CONSTRAINT `fk_agenda_servicos_agendamento1`
    FOREIGN KEY (`agendamento_id`)
    REFERENCES `agendamento` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_agenda_servicos_fornecedor_servicos1`
    FOREIGN KEY (`fornecedor_servicos_id`)
    REFERENCES `fornecedor_servicos` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


CREATE TABLE IF NOT EXISTS `chats` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `agendamento_id` INT NOT NULL,
  `status` CHAR(1) NULL DEFAULT 'A',
  `data_criacao` DATETIME NULL,
  PRIMARY KEY (`id`),
  INDEX `fk_chats_agendamento1_idx` (`agendamento_id` ASC),
  CONSTRAINT `fk_chats_agendamento1`
    FOREIGN KEY (`agendamento_id`)
    REFERENCES `agendamento` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

ALTER TABLE `usuario` 
ADD COLUMN `fornecedor_id` INT NULL AFTER `img_avatar`,
ADD INDEX `usuario_fornecedor_id_fk_idx` (`fornecedor_id` ASC);

ALTER TABLE `usuario` 
ADD CONSTRAINT `usuario_fornecedor_id_fk`
  FOREIGN KEY (`fornecedor_id`)
  REFERENCES `fornecedor` (`id`)
  ON DELETE NO ACTION
  ON UPDATE NO ACTION;

INSERT INTO categorias_fornecedor (id, nome_categoria, tipo_categoria) VALUES (1, 'Petshop', 'P');
INSERT INTO categorias_fornecedor (id, nome_categoria, tipo_categoria) VALUES (2, 'Veterinária', 'V');
INSERT INTO categorias_fornecedor (id, nome_categoria, tipo_categoria) VALUES (3, 'Pet Center', 'C');

ALTER TABLE `usuario` 
ADD UNIQUE INDEX `email_UNIQUE` (`email` ASC);


INSERT INTO `fornecedor` VALUES 
(null,'CLINICA  JARDIM','https://picsum.photos/seed/0.8414244473366295/300',null,'Rua Dunquerque','11222222222',0x000000000101000000871D215E32A137C0EAF4728EF03F47C0,1),
(null,'CLINICA VETERINARIA ATILIO','https://picsum.photos/seed/0.24412205558654113/300',null,'Rua Professor Atilio Innocenti','11222222222',0x000000000101000000D9DAB1C7FA9637C02FD2D567185747C0,1),
(null,'VETERINARIA FRADIQUE','https://picsum.photos/seed/0.06549930671742121/300',null,'Rua Fradique Coutinho','11222222222',0x000000000101000000DAA3DC22D58E37C09C5C42F45A5847C0,1),
(null,'VETERINARIA CENTRAL','https://picsum.photos/seed/0.04738860395493787/300',null,'Praça dos Omaguás','11222222222',0x000000000101000000D65AF33EE98F37C0EE6CD96B8B5847C0,2),
(null,'CLINICA VETERINARIA FARIA LIMA','https://picsum.photos/seed/0.3108899912898336/300',null,'Av Faria Lima','11222222222',0x000000000101000000EB1D6E87869537C0C1C018366F5747C0,1),
(null,'VET BERRINI','https://picsum.photos/seed/0.48041267551520156/300',null,'Rua Kansas','11222222222',0x00000000010100000065D93807749937C0707DB328475847C0,2),
(null,'CLINICA CENTRAL ABC','https://picsum.photos/seed/0.3298311897831328/300',null,'Rua Antônio Cubas','11222222222',0x000000000101000000607DF266C3A837C008A23891AA4547C0,1),
(null,'CLINICA MATRIZ','https://picsum.photos/seed/0.9430788028455142/300',null,'Av Juscelino Kubitscheck','11222222222',0x000000000101000000D6E3BED53A9737C084A867E66E5747C0,1),
(null,'CLINICA PADRE ANTONIO','https://picsum.photos/seed/0.9500168226193794/300',null,'Avenida Padre Antônio José dos Santos','11222222222',0x0000000001010000009B81DB24509C37C08FEA2A93D05747C0,3),
(null,'PET CENTER CENTRAL','https://picsum.photos/seed/0.5626106807613844/300',null,'RUA JOAQUIM TAVORA','11222222222',0x00000000010100000020578FA09D9637C092448A5CCB5247C0,3),
(null,'PET CENTER PRAÇA','https://picsum.photos/seed/0.13945180749469605/300',null,'Rua Ministro Jesuíno Cardoso','11222222222',0x0000000001010000004F0BB9AD889737C010BBA58B035747C0,1),
(null,'HOTEL E VET SALVA LUZ','https://picsum.photos/seed/0.5860884921495696/300',null,'AV ENG EUSEBIO STEVAUX','11222222222',0x0000000001010000004148163081AB37C020949CB8C15947C0,1),
(null,'PETCATE AUAU-MIAU','https://picsum.photos/seed/0.880615359992362/300',null,'AV HORACIO LAFER','11222222222',0x000000000101000000AC1919E42E9637C057050F78055747C0,1),
(null,'PETCENTER ANIMAIS LUZ','https://picsum.photos/seed/0.45689568711155626/300',null,'Rua Ribeiro do Vale','11222222222',0x000000000101000000EFFC474B8A9C37C0A2670EA4E65747C0,1),
(null,'CLINICA TUCUNARE - PRAÇA 2','https://picsum.photos/seed/0.7554800917911157/300',null,'Avenida Tucunar&eacute;','11222222222',0x000000000101000000C3ABF6FAA47E37C0A9F4B814FC6A47C0,1),
(null,'VET BALDERI','https://picsum.photos/seed/0.1813100512896758/300',null,'Rua Doutor Renato Paes de Barros','11222222222',0x000000000101000000B53E9B0B129537C044820420495647C0,1),
(null,'Hospital 24h Dr. Bacci','https://picsum.photos/seed/0.572463037979289/300',null,'Avenida Governador Julio Jose de Campos','11222222222',0x000000000101000000C75DCEB6E47830C0ECF1E780C94B4BC0,1),
(null,'VETERINARIA PETMANIA 2','https://picsum.photos/seed/0.24500753660221355/300',null,'Rua Caldas Novas','11222222222',0x0000000001010000000B94B99E8D8137C0555458045A6F47C0,2),
(null,'HOSPITAL VETERINARIO LUZ','https://picsum.photos/seed/0.5029761302312614/300',null,'Rua Gomes de Carvalho','11222222222',0x0000000001010000003D258C0BAC9837C09DA85B2CFB5747C0,1),
(null,'VETERINARIA SALVAÇÃO','https://picsum.photos/seed/0.3514789215768491/300',null,'Avenida Europa','11222222222',0x0000000001010000003703B749A09237C05FF4705D8C5647C0,1),
(null,'PETSHOP CALFAT','https://picsum.photos/seed/0.15131461448158567/300',null,'Rua Comendador Miguel Calfat','11222222222',0x000000000101000000AC76A801DE9737C04489963C9E5647C0,3),
(null,'VET RELIQUIA CENTRO','https://picsum.photos/seed/0.7116676575612907/300',null,'Rua Relíquia','11222222222',0x000000000101000000A94E07B29E8237C0821C4AA3B85447C0,1),
(null,'PETSHOP ANIMAMUNDI','https://picsum.photos/seed/0.15985423993305697/300',null,'Avenida Paulo Faccini','11222222222',0x0000000001010000002DF5E27ACA7437C08E0B62FB244447C0,3),
(null,'HOTEL E VET AU AU','https://picsum.photos/seed/0.6322219172792714/300',null,'Rua Tolentino Filgueiras','11222222222',0x000000000101000000CA4862EEFFF637C0C113C48A642A47C0,1);

 Insert into fornecedor_servicos VALUES
 (null,1,'HOTEL','45.00'),
 (null,1,'PETCARE','22.00'),
 (null,1,'VETERINARIO','59.00'),
 (null,2,'BANHO','23.00'),
 (null,2,'TOSA','30.00'),
 (null,2,'VETERINARIO','44.00'),
 (null,3,'TOSA','16.00'),
 (null,3,'PETCARE','35.00'),
 (null,3,'VETERINARIO','58.00'),
 (null,5,'TOSA','21.00'),
 (null,5,'HOTEL','49.00'),
 (null,5,'PETCARE','57.00'),
 (null,7,'BANHO','10.00'),
 (null,7,'HOTEL','55.00'),
 (null,7,'VETERINARIO','22.00'),
 (null,8,'BANHO','30.00'),
 (null,8,'HOTEL','20.00'),
 (null,8,'PETCARE','48.00'),
 (null,11,'TOSA','45.00'),
 (null,11,'PETCARE','40.00'),
 (null,11,'VETERINARIO','54.00'),
 (null,12,'BANHO','15.00'),
 (null,12,'HOTEL','55.00'),
 (null,12,'VETERINARIO','60.00'),
 (null,13,'BANHO','26.00'),
 (null,13,'TOSA','28.00'),
 (null,13,'PETCARE','35.00'),
 (null,14,'BANHO','23.00'),
 (null,14,'HOTEL','15.00'),
 (null,14,'VETERINARIO','29.00'),
 (null,15,'BANHO','46.00'),
 (null,15,'TOSA','22.00'),
 (null,15,'VETERINARIO','26.00'),
 (null,16,'HOTEL','58.00'),
 (null,16,'PETCARE','17.00'),
 (null,16,'VETERINARIO','49.00'),
 (null,17,'TOSA','22.00'),
 (null,17,'PETCARE','33.00'),
 (null,17,'VETERINARIO','48.00'),
 (null,19,'TOSA','58.00'),
 (null,19,'HOTEL','14.00'),
 (null,19,'PETCARE','17.00'),
 (null,20,'BANHO','55.00'),
 (null,20,'TOSA','15.00'),
 (null,20,'HOTEL','16.00'),
 (null,22,'TOSA','20.00'),
 (null,22,'HOTEL','40.00'),
 (null,22,'VETERINARIO','15.00'),
 (null,24,'BANHO','11.00'),
 (null,24,'TOSA','38.00'),
 (null,24,'HOTEL','51.00'),
 (null,25,'BANHO','56.00'),
 (null,25,'TOSA','27.00'),
 (null,25,'HOTEL','51.00'),
 (null,26,'BANHO','48.00'),
 (null,26,'PETCARE','10.00'),
 (null,26,'VETERINARIO','59.00'),
 (null,27,'BANHO','42.00'),
 (null,27,'PETCARE','20.00'),
 (null,27,'VETERINARIO','45.00'),
 (null,29,'TOSA','59.00'),
 (null,29,'HOTEL','57.00'),
 (null,29,'VETERINARIO','57.00'),
 (null,31,'BANHO','58.00'),
 (null,31,'PETCARE','43.00'),
 (null,31,'VETERINARIO','12.00'),
 (null,32,'BANHO','15.00'),
 (null,32,'TOSA','18.00'),
 (null,32,'VETERINARIO','37.00'),
 (null,35,'BANHO','57.00'),
 (null,35,'TOSA','40.00'),
 (null,35,'PETCARE','23.00'),
 (null,36,'BANHO','60.00'),
 (null,36,'PETCARE','60.00'),
 (null,36,'VETERINARIO','23.00'),
 (null,37,'BANHO','49.00'),
 (null,37,'HOTEL','37.00'),
 (null,37,'VETERINARIO','31.00'),
 (null,38,'TOSA','50.00'),
 (null,38,'HOTEL','58.00'),
 (null,38,'PETCARE','51.00'),
 (null,39,'BANHO','55.00'),
 (null,39,'PETCARE','50.00'),
 (null,39,'VETERINARIO','29.00'),
 (null,40,'BANHO','52.00'),
 (null,40,'TOSA','44.00'),
 (null,40,'VETERINARIO','45.00'),
 (null,41,'HOTEL','38.00'),
 (null,41,'PETCARE','59.00'),
 (null,41,'VETERINARIO','51.00'),
 (null,43,'HOTEL','18.00'),
 (null,43,'PETCARE','18.00'),
 (null,43,'VETERINARIO','18.00'),
 (null,44,'TOSA','33.00'),
 (null,44,'HOTEL','11.00'),
 (null,44,'VETERINARIO','29.00'),
 (null,46,'TOSA','19.00'),
 (null,46,'PETCARE','59.00'),
 (null,46,'VETERINARIO','21.00'),
 (null,48,'TOSA','53.00'),
 (null,48,'HOTEL','16.00'),
 (null,48,'VETERINARIO','47.00'),
 (null,4,'HOTEL','53.00'),
 (null,4,'PETCARE','15.00'),
 (null,4,'VETERINARIO','24.00'),
 (null,6,'BANHO','59.00'),
 (null,6,'TOSA','13.00'),
 (null,6,'VETERINARIO','20.00'),
 (null,18,'BANHO','31.00'),
 (null,18,'HOTEL','55.00'),
 (null,18,'VETERINARIO','48.00'),
 (null,28,'BANHO','57.00'),
 (null,28,'TOSA','58.00'),
 (null,28,'PETCARE','53.00'),
 (null,30,'TOSA','51.00'),
 (null,30,'HOTEL','58.00'),
 (null,30,'PETCARE','12.00'),
 (null,42,'BANHO','14.00'),
 (null,42,'TOSA','51.00'),
 (null,42,'VETERINARIO','28.00'),
 (null,9,'TOSA','51.00'),
 (null,9,'HOTEL','35.00'),
 (null,9,'PETCARE','10.00'),
 (null,10,'BANHO','45.00'),
 (null,10,'HOTEL','37.00'),
 (null,10,'PETCARE','32.00'),
 (null,21,'TOSA','29.00'),
 (null,21,'PETCARE','30.00'),
 (null,21,'VETERINARIO','47.00'),
 (null,23,'BANHO','28.00'),
 (null,23,'TOSA','32.00'),
 (null,23,'HOTEL','42.00'),
 (null,33,'BANHO','23.00'),
 (null,33,'TOSA','41.00'),
 (null,33,'PETCARE','34.00'),
 (null,34,'BANHO','53.00'),
 (null,34,'TOSA','49.00'),
 (null,34,'VETERINARIO','17.00'),
 (null,45,'TOSA','28.00'),
 (null,45,'PETCARE','50.00'),
 (null,45,'VETERINARIO','37.00'),
 (null,47,'TOSA','14.00'),
 (null,47,'HOTEL','46.00'),
 (null,47,'VETERINARIO','12.00');
