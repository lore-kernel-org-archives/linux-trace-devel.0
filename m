Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 12632C433E0
	for <linux-trace-devel@archiver.kernel.org>; Thu, 18 Feb 2021 03:39:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B9B5F64D74
	for <linux-trace-devel@archiver.kernel.org>; Thu, 18 Feb 2021 03:39:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229806AbhBRDjb (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 17 Feb 2021 22:39:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48342 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229752AbhBRDja (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 17 Feb 2021 22:39:30 -0500
Received: from mail-ej1-x630.google.com (mail-ej1-x630.google.com [IPv6:2a00:1450:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 69642C061574
        for <linux-trace-devel@vger.kernel.org>; Wed, 17 Feb 2021 19:38:50 -0800 (PST)
Received: by mail-ej1-x630.google.com with SMTP id ly28so1604464ejb.13
        for <linux-trace-devel@vger.kernel.org>; Wed, 17 Feb 2021 19:38:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=03GlYuFtwI5e8QWxMbNH9iLJKOggk9nrYwVVWI9YPxU=;
        b=gZigrf6f9VSs10eVzF8QkXFH8CqXXXMx9bmZcdQ/tbuUx2F+jlSVlHRZToQFGjaOmn
         h/WXv+qF6u0+18glWp1/iuVf573QoMzYUa63BRM9s3uJrufv825gdYHoYSlgFTloZaEn
         BeEJ5e8irg6ijw/OX3RncwlZp6r5M5Jd/WcWHGpwX95hPsfO/EMrHUABmo3aZB6r0Vce
         U6f5LoQusq+P5MIMgftdOxmoGIl3a9BNizD5PUE2QOKOZQQc4WbxCUNyyTeQ0/qzzhOj
         WVz5hDaikGgFea0U8gWgfjsfGZGki0r6qQ30U+OdkCgCcPeUARrKIFZWswW0ic6svbev
         Iliw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=03GlYuFtwI5e8QWxMbNH9iLJKOggk9nrYwVVWI9YPxU=;
        b=LlYSIa3Ew5iCjWXd2yFmJr9zMwvg3uPikkMYbrhBEFSiqwOpF+pIjhxpqtlBwcoxyV
         eykZBBk0xvJMyQWPgoeYY/cvcOI98qW6HREDIHHwPHUnV+alE7cV+yfSDfZsO9e9yAoM
         ukpoOTHqA6y5j4waMrQfMQ0LZa5JJgs4/GriDagAzmm2JHpwLqVfGE3/LoE/iUZtB7tP
         IdfhP7+oOCIbZivV2h+kcoibmMxPl0uS9UySEdWPQeAoMHmHk4kc5podbnoaZ3+C9IRi
         lrIfik/oV9YrCY8QEDvs2BK/c7TkkLEk7+cfmrnshfSuDVBlxsG3ow8ACLs+qoYe5c+K
         gNMQ==
X-Gm-Message-State: AOAM5339rd3I2zf7m59mPFbmdjMEhGfNQ3wZiEsUAUGe5G0gMOe924Xe
        uIjdyvfGotjEJUuQJjVjG+HOXX5ezluIiA==
X-Google-Smtp-Source: ABdhPJzhFsjOL9KfLzaJl7kYJEOGrLBioo7KecCmuV4+kACMhxBNgngIVzQIjbJM6Z78KgFsIHL38Q==
X-Received: by 2002:a17:906:9259:: with SMTP id c25mr1973410ejx.37.1613619528928;
        Wed, 17 Feb 2021 19:38:48 -0800 (PST)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id i4sm1796979eje.90.2021.02.17.19.38.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 17 Feb 2021 19:38:48 -0800 (PST)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH 0/2] Documentation for new libtracefs APIs
Date:   Thu, 18 Feb 2021 05:38:44 +0200
Message-Id: <20210218033846.1891289-1-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.29.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Documented recently added APIs for trace instances and trace options.

Tzvetomir Stoyanov (VMware) (2):
  libtracefs: Document new instance APIs
  libtracefs: Document APIs for trace options

 Documentation/libtracefs-instances-manage.txt |  34 +++-
 Documentation/libtracefs-instances-utils.txt  |  16 +-
 Documentation/libtracefs-option-bits.txt      |  90 ++++++++++
 Documentation/libtracefs-option-get.txt       | 123 ++++++++++++++
 Documentation/libtracefs-option-misc.txt      | 100 +++++++++++
 Documentation/libtracefs-options.txt          | 159 ++++++++++++++++++
 6 files changed, 513 insertions(+), 9 deletions(-)
 create mode 100644 Documentation/libtracefs-option-bits.txt
 create mode 100644 Documentation/libtracefs-option-get.txt
 create mode 100644 Documentation/libtracefs-option-misc.txt
 create mode 100644 Documentation/libtracefs-options.txt

-- 
2.29.2

