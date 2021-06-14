Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AF6E8C49360
	for <linux-trace-devel@archiver.kernel.org>; Mon, 14 Jun 2021 07:51:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9E6396124B
	for <linux-trace-devel@archiver.kernel.org>; Mon, 14 Jun 2021 07:51:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232591AbhFNHxJ (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 14 Jun 2021 03:53:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53068 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232589AbhFNHxH (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 14 Jun 2021 03:53:07 -0400
Received: from mail-ed1-x536.google.com (mail-ed1-x536.google.com [IPv6:2a00:1450:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D2E8FC061766
        for <linux-trace-devel@vger.kernel.org>; Mon, 14 Jun 2021 00:51:04 -0700 (PDT)
Received: by mail-ed1-x536.google.com with SMTP id ba2so43440943edb.2
        for <linux-trace-devel@vger.kernel.org>; Mon, 14 Jun 2021 00:51:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=grOKVMmRfFecxyDe/8UxFkVTzxTChc98bauEYxiRBO0=;
        b=Z3Y7Rf6Jbi3XVKfEVqvnPkrNlKIpJiDQlpzj1GMqNTyNMxcZjXWSAuqFGQ6U4vfn0c
         2TTLYtZYv+bUm1YWdQUlhViXHNp4ddhBrgQo+XUIi3DdA9kY/MdOb3IciusnCiJkYdKK
         dsrNaewMZ5IUluwd4XfTj1QrvJdjF52avGnisUnqIPk8M5buspOYKlHYoGLDZpFF6k++
         fygboK8ZK+5NdCMwrMz/62u8XO3fPYTHR1O4MfOS/CsiZ/iueFZIgMON6gUD3mcc9xQw
         cMlfxLuCJDfm1lB7X2eOtkX6XJq/BaEdqFFag/t4qxJNJNMJelvu9JHi4TZFS+/a/mRS
         qF/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=grOKVMmRfFecxyDe/8UxFkVTzxTChc98bauEYxiRBO0=;
        b=smgzkjB7Yf0rhAwD6rc+kSYml8J1EnnUHjPRiY6glZtN/hsu5vrVssipIir5OZX39W
         mIvek9Po53YdU5KGnqBCQLO4mVArkGcAuF7CZGYOkSkvbDs6xQ6EOxVB79mVRKbaAdvv
         tBtWOHh5+L9dYJ4IfYLj2PtZZs6Drg3aD2AizKYa5vfN7wToD0bFv6SBQruk+hVqfXSH
         RC8TWf8NKCMR79BLeaIsH9gztERd3DaHPssWJUd4jRfU0mkLRbQcbeP7GB6rnYm3xQY9
         VdFLwnRYQI9tTCkaqW47x+07dkKx1s6sYDug76LmwjHIysxlHQjwUojCb0PDNTgpTKav
         5/gA==
X-Gm-Message-State: AOAM530un/bVtQKbWEzC5QAQ+dcEv4goDoFzq8nZHgwn9hkT+D1XjR4s
        YckFtM+1WWrT+frzF43NPiY4GkVVZ6+S8w==
X-Google-Smtp-Source: ABdhPJyG1iShsWAvJ0FA8aHuH44g67Qf3h0loJZWY1sAkiAkkKGeFRfF3sTPYuHT20X43o7oMp3oyg==
X-Received: by 2002:a05:6402:27d1:: with SMTP id c17mr15487183ede.28.1623657063449;
        Mon, 14 Jun 2021 00:51:03 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id f6sm6536444eja.108.2021.06.14.00.51.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Jun 2021 00:51:03 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v6 33/45] trace-cmd: Copy CPU count in tracecmd_copy
Date:   Mon, 14 Jun 2021 10:50:17 +0300
Message-Id: <20210614075029.598048-34-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210614075029.598048-1-tz.stoyanov@gmail.com>
References: <20210614075029.598048-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Extend the tracecmd_copy() API to support copying of CPU count from
input to output trace hanlder.

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 lib/trace-cmd/trace-input.c  | 30 ++++++++++++++++++++++++++++++
 lib/trace-cmd/trace-output.c |  2 +-
 2 files changed, 31 insertions(+), 1 deletion(-)

diff --git a/lib/trace-cmd/trace-input.c b/lib/trace-cmd/trace-input.c
index 74d1ebf7..289102bf 100644
--- a/lib/trace-cmd/trace-input.c
+++ b/lib/trace-cmd/trace-input.c
@@ -4043,6 +4043,23 @@ error:
 	return -1;
 }
 
+static int copy_cpu_count(struct tracecmd_input *in_handle, struct tracecmd_output *out_handle)
+{
+	unsigned int size;
+
+	if (!check_in_state(in_handle, TRACECMD_FILE_CPU_COUNT) ||
+	    !check_out_state(out_handle, TRACECMD_FILE_CPU_COUNT))
+		return -1;
+
+	if (read_copy_size4(in_handle, out_handle, &size) < 0)
+		return -1;
+
+	in_handle->file_state = TRACECMD_FILE_CPU_COUNT;
+	out_set_file_state(out_handle, in_handle->file_state);
+
+	return 0;
+}
+
 /**
  * tracecmd_copy_headers - Copy headers from a tracecmd_input handle to a file descriptor
  * @in_handle: input handle for the trace.dat file to copy from.
@@ -4135,6 +4152,19 @@ int tracecmd_copy_headers(struct tracecmd_input *in_handle,
 			return 0;
 
 		ret = copy_command_lines(in_handle, out_handle);
+		if (ret < 0)
+			goto out;
+
+		/* fallthrough */
+	case TRACECMD_FILE_CPU_COUNT:
+		if (end_state <= in_handle->file_state)
+			return 0;
+
+		ret = copy_cpu_count(in_handle, out_handle);
+		if (ret < 0)
+			goto out;
+
+		/* fallthrough */
 	default:
 		break;
 	}
diff --git a/lib/trace-cmd/trace-output.c b/lib/trace-cmd/trace-output.c
index 806c833c..b4bdaeeb 100644
--- a/lib/trace-cmd/trace-output.c
+++ b/lib/trace-cmd/trace-output.c
@@ -1949,7 +1949,7 @@ struct tracecmd_output *tracecmd_copy(struct tracecmd_input *ihandle, const char
 	if (!handle)
 		return NULL;
 
-	fstate = state > TRACECMD_FILE_CMD_LINES ? TRACECMD_FILE_CMD_LINES : state;
+	fstate = state > TRACECMD_FILE_CPU_COUNT ? TRACECMD_FILE_CPU_COUNT : state;
 	if (tracecmd_copy_headers(ihandle, handle, 0, fstate) < 0)
 		goto out_free;
 
-- 
2.31.1

