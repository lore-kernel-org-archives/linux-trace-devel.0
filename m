Return-Path: <SRS0=5FGG=3E=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4B1E2C32771
	for <linux-trace-devel@archiver.kernel.org>; Wed, 15 Jan 2020 18:06:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 20C9F2187F
	for <linux-trace-devel@archiver.kernel.org>; Wed, 15 Jan 2020 18:06:56 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="NlPIqJYM"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728896AbgAOSG4 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 15 Jan 2020 13:06:56 -0500
Received: from mail-lf1-f65.google.com ([209.85.167.65]:36714 "EHLO
        mail-lf1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728921AbgAOSGz (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 15 Jan 2020 13:06:55 -0500
Received: by mail-lf1-f65.google.com with SMTP id n12so13438606lfe.3
        for <linux-trace-devel@vger.kernel.org>; Wed, 15 Jan 2020 10:06:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=wjWZ6LjNbGV2kuay6QBMaTRMAQ7hbuEYFR3eyDBCrIU=;
        b=NlPIqJYMZz9jwMtlrKkbr5U+S+M4Pi76vbARQCDgRQZVnM/DCWmiP69d4kH/DaiomE
         KdKUNPy/nljgS8XySod7ND1HPPwV1aWpcm6HsZojcFRcqyrvZl1Mor0UItV96paE7zoc
         KRTTZgzwkSd4zhrFFsnbOPAODXM/snMdNU5tG7LE6eCPYWHXJYZ9M2KDc+ceO6fz8rXj
         VgxWRmdwdqDEr6Mdm9kBOjDhcsp6lD0OD6NvgEHME6r7z39tNuKBHj4+W3BsYZxIYC7E
         m1sgBvXksLIelkKyatYMWHx0iiffP+I+9OqOhioO79Yp3mM5g0LDEWcqlNyVyTYWPqNM
         7UzA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=wjWZ6LjNbGV2kuay6QBMaTRMAQ7hbuEYFR3eyDBCrIU=;
        b=Ml38Z0raDNzSDQxXdMD0zSPpyBpQEigjfFgyD54dGUBSWQf+7IWeaFMEZpeKnW6hur
         7DLdBPh75IuiGobdSs3YzatdBJohUM5/abz1wC39sL15RJncXacxD1Q1v3rOvFKGWdAu
         CgbqMlnGvGKoyyylo391jaYgjzDwidgapurrUW9yCH1VzWMKHQ0cf4mL/42uCkwwYilr
         Z+24jt2XdUrf5FXU2k552EXQ/rkBy0ASFqTzeTD7uhFDWo2gZiw1cIuHb1v0ahVX3bV4
         mxkjLcIu2Y/PP4z0zlwMCE+fEqM5it4qq2p8aTuuJWHzfGE3c760Qkp09pM+BV0uUkQL
         1PlQ==
X-Gm-Message-State: APjAAAXCpmI7+vjNjqfXThGk524HqbCn1YeitaV1TK7GA9qOLuyT41Dp
        ZU5ot/wenU/Yk/ICX8xdBuKrW0QA2Yqbpg==
X-Google-Smtp-Source: APXvYqzgD/9pc33QpQ6BjfbfnySfsbYnXy/L18Q4LFimNuRpnW7fDGpgXz+mIwhjqpukqMvWIfLf9Q==
X-Received: by 2002:ac2:5592:: with SMTP id v18mr50007lfg.17.1579111613776;
        Wed, 15 Jan 2020 10:06:53 -0800 (PST)
Received: from localhost.localdomain (hq.kranx.com. [81.211.121.154])
        by smtp.gmail.com with ESMTPSA id s12sm10992867ljo.9.2020.01.15.10.06.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Jan 2020 10:06:53 -0800 (PST)
From:   Ivan Prisyazhnyy <john.koepi@gmail.com>
To:     linux-trace-devel@vger.kernel.org
Cc:     Steven Rostedt <rostedt@goodmis.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Ivan Prisyazhnyy <john.koepi@gmail.com>
Subject: [PATCH bpf] traceevent: ignore __attribute__ in fields format
Date:   Wed, 15 Jan 2020 20:06:45 +0200
Message-Id: <20200115180645.53331-1-john.koepi@gmail.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <CAJ8z9b1RD4gyPg8_B2sW=ULEjLRLTZrCAWc=k2=d8wSrhMBbOQ@mail.gmail.com>
References: <CAJ8z9b1RD4gyPg8_B2sW=ULEjLRLTZrCAWc=k2=d8wSrhMBbOQ@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

To support kernel (e.g. Arch linux) tracing that
have events fields with C attributes (__attribute__((xxx))),
traceevent must ignore __attribute__ parts when
parsing fields types.

An example from Arch linux kernel 4.2:

  $ cat /sys/kernel/.../sys_enter_io_submit/format
  ...
  field:struct iocb __attribute__((user)) * ...
                    ^^^

This fix adds support for fields types C attributes
parsing to event_read_fields function. When it sees
__attribute__ ((attribute-list)) expression it skips
it.

Fixes: https://bugzilla.kernel.org/show_bug.cgi?id=205857
Base: https://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf.git/
Signed-off-by: Ivan Prisyazhnyy <john.koepi@gmail.com>
---
 tools/lib/traceevent/event-parse.c | 22 ++++++++++++++++++++++
 1 file changed, 22 insertions(+)

diff --git a/tools/lib/traceevent/event-parse.c b/tools/lib/traceevent/event-parse.c
index beaa8b8c08ff..fbc1ea536742 100644
--- a/tools/lib/traceevent/event-parse.c
+++ b/tools/lib/traceevent/event-parse.c
@@ -1486,6 +1486,28 @@ static int event_read_fields(struct tep_event *event, struct tep_format_field **
 			    (event->flags & TEP_EVENT_FL_ISFTRACE &&
 			     type == TEP_EVENT_OP && strcmp(token, ".") == 0)) {
 
+				/* ignore C attributes: __attribute__((expr)) */
+				if (strcmp(token, "__attribute__") == 0) {
+					free(token);
+					for (int i = 0; i < 2; i++) {
+						if (read_expected_item(TEP_EVENT_DELIM, "(") < 0) {
+							goto fail_expect;
+						}
+					}
+					for (int brackets = 2; brackets > 0;) {
+						if (read_token(&token) == TEP_EVENT_NONE) {
+							do_warning_event(event, "%s: __attribute__ not full", __func__);
+							goto fail_expect;
+						}
+						if (strcmp(token, "(") == 0)
+							brackets++;
+						else if (strcmp(token, ")") == 0)
+							brackets--;
+						free(token);
+					}
+					continue;
+				}
+
 				if (strcmp(token, "*") == 0)
 					field->flags |= TEP_FIELD_IS_POINTER;
 
-- 
2.24.1

