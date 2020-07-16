Return-Path: <SRS0=576e=A3=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.1 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2E139C433E8
	for <linux-trace-devel@archiver.kernel.org>; Thu, 16 Jul 2020 09:19:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 08E9D20656
	for <linux-trace-devel@archiver.kernel.org>; Thu, 16 Jul 2020 09:19:32 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="a3FiUYu3"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726863AbgGPJTb (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 16 Jul 2020 05:19:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56064 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726585AbgGPJTb (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 16 Jul 2020 05:19:31 -0400
Received: from mail-ed1-x544.google.com (mail-ed1-x544.google.com [IPv6:2a00:1450:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2D347C061755
        for <linux-trace-devel@vger.kernel.org>; Thu, 16 Jul 2020 02:19:31 -0700 (PDT)
Received: by mail-ed1-x544.google.com with SMTP id h28so4255187edz.0
        for <linux-trace-devel@vger.kernel.org>; Thu, 16 Jul 2020 02:19:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=YuEEjolJbRPDpv8irdFKFzEge/lWCtPeCNl55tP0drA=;
        b=a3FiUYu3xquDChC2/Uwj02rDlYZwEo3lfWzSe1ipVUPR6b00/RokXCeet7YeyAkkWB
         zMRL1ea5vqwnWAcl5tTQxdkmx8pK2lIC8dILLiMYg0c9N2N9fxyiAXSBLrsO7rDUG/q/
         47a/0gjGMKNf4bB/CDGvqzOYCfr6COgTioup5PMcVBocSR6cnMI023KvcoMuTI8TascQ
         /8hSBTKIGFKM+mIQmoHql0Qlda4dqAQNp1xh5eB+ZpNay+IPYLHVS8q9qJle0xkALJnl
         oD0QxFiB8vZt64m5D5PL/SzmdK416gHICHWiwVGh2HRN3JjHElHc67yxxfgjA/ClMJc7
         w9Ew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=YuEEjolJbRPDpv8irdFKFzEge/lWCtPeCNl55tP0drA=;
        b=lV9Fe1OfhxK3Ne81Id9ggNRFwRkC85rSnND2nAVrRPnGqB3g44xhO7gd1P4j6MRMP2
         hhO9zDtVbbnyg3Ro5IvwvhP9QkU408LVMzcBxSVO7x9ecQhOJo8muHwbelzDeQcpNRB2
         D7D7C3xeWZFJpu7Pb7if3plrjuttWhLH8TzXF0eZnLWJA+9k8Nhw3MTYATM4pcjV/kBD
         0vThpRtJtxSSiSOJumLOYJuI0Ls6Pl5yOKvcsLb1ZdyjlK1/dvRIIYHUcBa+nO90FuyQ
         2mhQdLue2hLUXzyJoKj22p68gHErU69oDCII8lee6xKCDs5HAtvmI43gfk8j76n2Zod1
         YCqg==
X-Gm-Message-State: AOAM532cNrDvkh2WDfOGop5ra6J7cUpo9FTzsNMsohai/oNCUTggkFQL
        lzt4qsL/LFVSxbxVozKm17xlqCE/Da8=
X-Google-Smtp-Source: ABdhPJxPNQHNzdkSWs1Z0APlodh8e8JzzyzrL8rMIbNchcDwrjP7C+FZxvJLfKiee0jMQJQjvagq2w==
X-Received: by 2002:aa7:cf02:: with SMTP id a2mr3616577edy.263.1594891169945;
        Thu, 16 Jul 2020 02:19:29 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id x9sm4431534ejw.28.2020.07.16.02.19.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Jul 2020 02:19:29 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH 3/8] tools lib traceevent: Fix typo in tep_plugin_add_option() description
Date:   Thu, 16 Jul 2020 12:19:18 +0300
Message-Id: <20200716091923.2613228-4-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200716091923.2613228-1-tz.stoyanov@gmail.com>
References: <20200716091923.2613228-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

A typo "optiona" -> "optional" is fixed in description of
tep_plugin_add_option() API.

Link: https://lore.kernel.org/r/CAM9d7cizjF+fbK7YzmsBDgrx__4YAOsmEq67D3sWET8FF+YdFA@mail.gmail.com
Link: https://lore.kernel.org/linux-trace-devel/20200714103027.2477584-4-tz.stoyanov@gmail.com

Suggested-by: Namhyung Kim <namhyung@kernel.org>
Acked-by: Namhyung Kim <namhyung@kernel.org>
Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
---
 tools/lib/traceevent/event-plugin.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/lib/traceevent/event-plugin.c b/tools/lib/traceevent/event-plugin.c
index a39eeb6ef1f2..f8d253a61970 100644
--- a/tools/lib/traceevent/event-plugin.c
+++ b/tools/lib/traceevent/event-plugin.c
@@ -310,7 +310,7 @@ static int process_option(const char *plugin, const char *option, const char *va
 /**
  * tep_plugin_add_option - add an option/val pair to set plugin options
  * @name: The name of the option (format: <plugin>:<option> or just <option>)
- * @val: (optiona) the value for the option
+ * @val: (optional) the value for the option
  *
  * Modify a plugin option. If @val is given than the value of the option
  * is set (note, some options just take a boolean, so @val must be either
-- 
2.26.2

