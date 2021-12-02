Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3692BC433F5
	for <linux-trace-devel@archiver.kernel.org>; Thu,  2 Dec 2021 12:27:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240414AbhLBMa4 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 2 Dec 2021 07:30:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37106 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233967AbhLBMaz (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 2 Dec 2021 07:30:55 -0500
Received: from mail-ed1-x530.google.com (mail-ed1-x530.google.com [IPv6:2a00:1450:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7808EC06174A
        for <linux-trace-devel@vger.kernel.org>; Thu,  2 Dec 2021 04:27:33 -0800 (PST)
Received: by mail-ed1-x530.google.com with SMTP id y12so115227684eda.12
        for <linux-trace-devel@vger.kernel.org>; Thu, 02 Dec 2021 04:27:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=cilZ0IFiLox+aidlI21vhwNnKufJ982VhRU5hNioMJ8=;
        b=ddyiNW3ahqYVmG6W/kw8/8TvUMJnYk/dEGqQihKES7SfOl59GnUq2X85NXAIAIqcxn
         NSj4wBmqBU/xEUABqJ+Lmp7quXCGa5LgesipNy2WMAbmBrtgiLyVHZkiQgk3sAXVRaYa
         ZcNodUaHWdPu63eg0pVeQ1NROziS0hwDi/r0tqeLtV7imnSFZ91ZcEazSTrLYLGSne/2
         QKEpv2B40oURr5pz1EfM6i+BPWYrWnMfiYDhBB3eNIkvBs2Gm08cFWSC9Y/zLr6MuRVf
         BK2r3T3cjNfySjnMdbmF3KSnLKzeuFdwWu3XWNdlheuhQlJgo7ytw66nzHFBJ/dkyPx0
         SSqg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=cilZ0IFiLox+aidlI21vhwNnKufJ982VhRU5hNioMJ8=;
        b=pNn7OzA1v43HzN48oSqRMITsUIW/lJ5wE0XSWq4M+TC6G85b+LYRErzA736bXLTWFN
         0DFgXf6N2bkOCFgQohXCreyssqwant5WHOEwwpapvGJfgfJolJUcJNAtzgjrukU0yk8z
         M4GgVps/jqscy8KdZSis+jQtMc2PXbgRA6EZ1f0pkPgoMVA7vUdnbc2uWfwPhtdpH+jB
         o2ST8jgRjbXu+tceApnmy8t4Cc8R8Wb8pbi99SHZ5GAFd+BbhKG9FvoReXZi3Bgo/TId
         QVVUKjsFtB3oFB5LqpgOQevxk7Ih8ca2qScNzRx3qykcGj517d5VXtOX93J8HQugdAtF
         lbpw==
X-Gm-Message-State: AOAM533er+QD0EqQCAnSB1bnLx9HI5vJbK1HsKKOs97hUE8ZDNwx4YZE
        +tISet6v+T5Iqu3dG2IDYA3Vwb5/SSKVzQ==
X-Google-Smtp-Source: ABdhPJz0lJhQDewOEYAXQyUjkmn3Q8uZ0ueZhv0zo1x0NHFyFDaoAGxV4LMzXDTMMhqTV5pRn4WDdw==
X-Received: by 2002:a05:6402:1450:: with SMTP id d16mr17565625edx.144.1638448051698;
        Thu, 02 Dec 2021 04:27:31 -0800 (PST)
Received: from oberon.zico.biz.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id u16sm2073403edr.43.2021.12.02.04.27.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Dec 2021 04:27:31 -0800 (PST)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v5 4/8] trace-cmd library: New API to copy buffer description between trace files
Date:   Thu,  2 Dec 2021 14:27:22 +0200
Message-Id: <20211202122726.43775-5-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211202122726.43775-1-tz.stoyanov@gmail.com>
References: <20211202122726.43775-1-tz.stoyanov@gmail.com>
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
index 9e2cfcdb..58afb455 100644
--- a/lib/trace-cmd/include/private/trace-cmd-private.h
+++ b/lib/trace-cmd/include/private/trace-cmd-private.h
@@ -189,6 +189,8 @@ int tracecmd_copy_headers(struct tracecmd_input *in_handle,
 			  struct tracecmd_output *out_handle,
 			  enum tracecmd_file_states start_state,
 			  enum tracecmd_file_states end_state);
+int tracecmd_copy_buffer_descr(struct tracecmd_input *in_handle,
+			       struct tracecmd_output *out_handle);
 void tracecmd_set_flag(struct tracecmd_input *handle, int flag);
 void tracecmd_clear_flag(struct tracecmd_input *handle, int flag);
 unsigned long tracecmd_get_flags(struct tracecmd_input *handle);
diff --git a/lib/trace-cmd/trace-input.c b/lib/trace-cmd/trace-input.c
index 4cfe26bc..98c809c6 100644
--- a/lib/trace-cmd/trace-input.c
+++ b/lib/trace-cmd/trace-input.c
@@ -4889,6 +4889,19 @@ int tracecmd_copy_headers(struct tracecmd_input *in_handle,
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

