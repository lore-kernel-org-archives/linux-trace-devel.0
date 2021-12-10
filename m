Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2B990C433FE
	for <linux-trace-devel@archiver.kernel.org>; Fri, 10 Dec 2021 11:02:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240182AbhLJLGb (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 10 Dec 2021 06:06:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36334 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234606AbhLJLGa (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 10 Dec 2021 06:06:30 -0500
Received: from mail-ed1-x52c.google.com (mail-ed1-x52c.google.com [IPv6:2a00:1450:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 036FAC061746
        for <linux-trace-devel@vger.kernel.org>; Fri, 10 Dec 2021 03:02:56 -0800 (PST)
Received: by mail-ed1-x52c.google.com with SMTP id o20so29031471eds.10
        for <linux-trace-devel@vger.kernel.org>; Fri, 10 Dec 2021 03:02:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=4+zUlz5ygZg1GNrBk95NsVYApf9MSRcKecMlNksULIs=;
        b=PFyA7rpJxn30x3eDPT8RIM59cg1wV99UbKdEXvuOCqY6UFFKtnIcOIfn7DcUhxfXj2
         7DAxZvN0UjtQ37s+Da17TXc7dqufsmUQ7WXSwFZakmUzHiu1qdvLDlr5dqBDGxpgaNBK
         Pj3oTuYWHgHlZ6xH2vq1IFHhCesh+tAUcF67YsHG615O5LQFrmN4NS0e2Vnamani0dDo
         KXaWLcQTHUiJyueYU4HGZl+4y/h/o/yyXyqHgoY27p+8j3gYu+Tyx59xC0pmdUzJO71g
         w44UgwV5zXR0HtDCLByfxoX7HeZ0q1d5N5G625C4DI5eSzMJ6fnhCrY9BnVRCfrzL8/w
         6JMg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=4+zUlz5ygZg1GNrBk95NsVYApf9MSRcKecMlNksULIs=;
        b=utT9jW6r5wsN8/Qhqpq2AwJ0rus3YThBJiBpzxRyJWnIFUe8DyDImA7m8mrFXWUhyi
         +gpS4RCHCoJrMa+Wpmw7bYXc1KM2kFYZl1eejhqX6nFBdKCrF1hM5LQTmw5hJ9hSiof9
         fy9oFkbqIjnAmvo9vThc8/l9RvZinXNC+trjx9np1khMFMbDQe88tJ53Vzt8Vq3oPJOO
         PBsSDIxm0qYTZvZrnqtX4l2i7phfe7r1MSCRrINHyl7RT0E7rJwqHIbZKQhFi6eVbDbe
         3Dt6Hvb/p66JUruY/J+5TY1wM9PoZWb3K5II4CX/XH1pmOXswX8QmAkJadbig0s+OxWe
         kNPA==
X-Gm-Message-State: AOAM533XE5ZwL3kkIRQVo+seADzLWlv4m6I1AOjtbpRq7OxWxbgCu8ch
        6fZ2/w4sATGmKQnEnD297Ism80/6cnw=
X-Google-Smtp-Source: ABdhPJwMewHbrXFJ1FuZwyGcUQMLRz72tdubCbhPxNASjedte0fbFUb39OrgBy+oHToWxm+hIJi2rw==
X-Received: by 2002:a05:6402:1453:: with SMTP id d19mr36075483edx.388.1639134174491;
        Fri, 10 Dec 2021 03:02:54 -0800 (PST)
Received: from oberon.zico.biz.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id sg39sm1275269ejc.66.2021.12.10.03.02.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Dec 2021 03:02:54 -0800 (PST)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v6 4/9] trace-cmd library: New API to copy buffer description between trace files
Date:   Fri, 10 Dec 2021 13:02:44 +0200
Message-Id: <20211210110249.98583-5-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211210110249.98583-1-tz.stoyanov@gmail.com>
References: <20211210110249.98583-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

A new library API is introduced, to copy buffers description between
trace files:
	tracecmd_copy_buffer_descr()

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 lib/trace-cmd/include/private/trace-cmd-private.h |  2 ++
 lib/trace-cmd/trace-input.c                       | 13 +++++++++++++
 2 files changed, 15 insertions(+)

diff --git a/lib/trace-cmd/include/private/trace-cmd-private.h b/lib/trace-cmd/include/private/trace-cmd-private.h
index a6088e23..cde33553 100644
--- a/lib/trace-cmd/include/private/trace-cmd-private.h
+++ b/lib/trace-cmd/include/private/trace-cmd-private.h
@@ -190,6 +190,8 @@ int tracecmd_copy_headers(struct tracecmd_input *in_handle,
 			  struct tracecmd_output *out_handle,
 			  enum tracecmd_file_states start_state,
 			  enum tracecmd_file_states end_state);
+int tracecmd_copy_buffer_descr(struct tracecmd_input *in_handle,
+			       struct tracecmd_output *out_handle);
 void tracecmd_set_flag(struct tracecmd_input *handle, int flag);
 void tracecmd_clear_flag(struct tracecmd_input *handle, int flag);
 unsigned long tracecmd_get_flags(struct tracecmd_input *handle);
diff --git a/lib/trace-cmd/trace-input.c b/lib/trace-cmd/trace-input.c
index 4d9535b7..61a3a4b9 100644
--- a/lib/trace-cmd/trace-input.c
+++ b/lib/trace-cmd/trace-input.c
@@ -4957,6 +4957,19 @@ int tracecmd_copy_headers(struct tracecmd_input *in_handle,
 	return ret < 0 ? -1 : 0;
 }
 
+int tracecmd_copy_buffer_descr(struct tracecmd_input *in_handle,
+			       struct tracecmd_output *out_handle)
+{
+	int i;
+
+	if (tracecmd_get_out_file_version(out_handle) >= FILE_VERSION_SECTIONS)
+		return 0;
+
+	for (i = 0; i < in_handle->nr_buffers; i++)
+		tracecmd_add_buffer_info(out_handle, in_handle->buffers[i].name, 0);
+	return tracecmd_write_buffer_info(out_handle);
+}
+
 /**
  * tracecmd_record_at_buffer_start - return true if record is first on subbuffer
  * @handle: input handle for the trace.dat file
-- 
2.33.1

