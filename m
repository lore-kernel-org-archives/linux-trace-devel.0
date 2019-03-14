Return-Path: <SRS0=grb/=RR=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F2C1CC43381
	for <linux-trace-devel@archiver.kernel.org>; Thu, 14 Mar 2019 15:10:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C3AE420811
	for <linux-trace-devel@archiver.kernel.org>; Thu, 14 Mar 2019 15:10:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726539AbfCNPKe (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 14 Mar 2019 11:10:34 -0400
Received: from mail-pf1-f194.google.com ([209.85.210.194]:46918 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726360AbfCNPKe (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 14 Mar 2019 11:10:34 -0400
Received: by mail-pf1-f194.google.com with SMTP id s23so4015021pfe.13
        for <linux-trace-devel@vger.kernel.org>; Thu, 14 Mar 2019 08:10:34 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Ef6nhdk31VjtfcmxyPLsDWeiOqYm80MfCr+s976Ei0I=;
        b=AF11zp7zLL6YLx9blNKOBvnMjOaSODEWykC+zvYbkhyMTu9bqRbetMMpVEVuB0X9Ev
         Kghv+jzHSbTWj6LT17xx9X1DQYzAnfqfBqkGz3v3xKgy8GzhfxhFASjUFI4BfrT67bKO
         AW2MMPRbKP9fQiXOIIiJouGc0RYl237PEYjbXjsrhEAjrXzuhPY4Mxa28hb6vhlHJLN2
         dP2qkJX6I7MKEeJA5rk+wIS1DDmthBS00MbeYWug8ZuWl1mdz7deSx6IoQZyVm/I0wmk
         mqW1u0mNpUrClvLBgPwRjNCpHPnHQVATXsVXj8Tapylss4+gqAk4wUYJolvXo4mXTVEh
         a5Tg==
X-Gm-Message-State: APjAAAUFts+1ikVa//B9awEfmOc/6srvX8L9wRufR75G/pzMhgc/guNp
        JZDpOSZNT1ljjPac9oTt3yZjBMiC
X-Google-Smtp-Source: APXvYqzWgyRdGn+yIStALFIatUB9BzKCodtxI9GNBoBVA4sCY14Xb+/vUTULeJJP8FraNIHcMDuIRQ==
X-Received: by 2002:a17:902:547:: with SMTP id 65mr51986466plf.242.1552576233881;
        Thu, 14 Mar 2019 08:10:33 -0700 (PDT)
Received: from mamba.eng.vmware.com ([146.247.46.5])
        by smtp.gmail.com with ESMTPSA id f65sm8165585pfg.98.2019.03.14.08.10.32
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 14 Mar 2019 08:10:33 -0700 (PDT)
From:   Yordan Karadzhov <ykaradzhov@vmware.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH 02/12] kernel-shark: Fix a typo in an error message from libkshark-configio
Date:   Thu, 14 Mar 2019 17:10:02 +0200
Message-Id: <20190314151012.905-3-ykaradzhov@vmware.com>
X-Mailer: git-send-email 2.19.1
In-Reply-To: <20190314151012.905-1-ykaradzhov@vmware.com>
References: <20190314151012.905-1-ykaradzhov@vmware.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

The error message, printed whene kshark_open_json_file() fails, puts
the period on a new line.

Signed-off-by: Yordan Karadzhov <ykaradzhov@vmware.com>
---
 kernel-shark/src/libkshark-configio.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel-shark/src/libkshark-configio.c b/kernel-shark/src/libkshark-configio.c
index ab88864..2bd5600 100644
--- a/kernel-shark/src/libkshark-configio.c
+++ b/kernel-shark/src/libkshark-configio.c
@@ -1624,7 +1624,7 @@ static struct json_object *kshark_open_json_file(const char *file_name,
 
  fail:
 	/* The document has a wrong type. */
-	fprintf(stderr, "Failed to open Json file %s\n.", file_name);
+	fprintf(stderr, "Failed to open Json file %s.\n", file_name);
 	fprintf(stderr, "The document has a wrong type.\n");
 
 	json_object_put(jobj);
-- 
2.19.1

