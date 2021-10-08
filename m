Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 90B57C433F5
	for <linux-trace-devel@archiver.kernel.org>; Fri,  8 Oct 2021 04:25:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7A7C761090
	for <linux-trace-devel@archiver.kernel.org>; Fri,  8 Oct 2021 04:25:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229501AbhJHE1N (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 8 Oct 2021 00:27:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50988 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229634AbhJHE1N (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 8 Oct 2021 00:27:13 -0400
Received: from mail-ed1-x52d.google.com (mail-ed1-x52d.google.com [IPv6:2a00:1450:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1B08EC061755
        for <linux-trace-devel@vger.kernel.org>; Thu,  7 Oct 2021 21:25:18 -0700 (PDT)
Received: by mail-ed1-x52d.google.com with SMTP id a25so15499778edx.8
        for <linux-trace-devel@vger.kernel.org>; Thu, 07 Oct 2021 21:25:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=PstYDX3sMQHFzuY5HDAG6bxHmlxWc4WgjGrEgJA2+T0=;
        b=PpRJ6F3xMwoO+cMLOikFfHz4+EVHdp+Ry24nvJGyV+0XmH0IoMlQXF/7G/LwjCCdyS
         CaxXmhpTM5No7pql8rQ+JXt/PpE83xCDu+t294J5mYVSsgruK7GxdUPl8u+Gu/PSc61o
         y7Z10KUX+PrwvEEqnVFA+Vy+S1xYpJbDqbF2okkzTXih54SUjqDmCPC1kD3Kz4uFCDfH
         YGuNJqYITekToa0lUqeQUBcAShRJnyggJceELMsbTHfM+H35Qz2937UC9U1GTP7/4QjG
         9bHl4o5kkjko/y/qaup8LQAyT+psu0j1P3y9DSvdc4/YQLp8jZRUPkNGxyXpO6D9h+ql
         a/Aw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=PstYDX3sMQHFzuY5HDAG6bxHmlxWc4WgjGrEgJA2+T0=;
        b=UkUy+g8BcLeVrVEhE+wmpgLAp6lI8C2ClmsGNjG4VMFZd/onaKZojd4MB86JGW43Aa
         Tub5alhI5qOvgL0i2p3FwbPZ24JybSl5eMyQMgNIvEKofIeAh0bTKy6iiGOOn2CwjnWw
         ML8WAu05y6j1tb3OnoQqfWsCyzUvWeNLRTHqGHlc7ERWK1tw1Wbj7nIuyIQRcKUcP0og
         BpXwfQUgHVBTjNHlZbleG7M4aaZ/AFdPgMbddrHbWTse1DUvJ3YCfXKzHDTXuJYpf6SS
         7gx79G/UexFeg3y5lzy2DnQLeigaSvbZMDaUydf3LUhTeEiXvd154TdHFKZufoG0JuBP
         t7FA==
X-Gm-Message-State: AOAM531FEEsrlhIa3MmxhWBX42feMvVq02JD1K1RT4GQRRJTeVOlL9TI
        s34D0oJGL6jqQDXWORHyTFyGLPk/OwBzZA==
X-Google-Smtp-Source: ABdhPJylQVPp4p61i5Z9w685lnA1VYKzXLxs10nGNGiyxG/rN3eLEKQt4ui4dd++Ju+/J2318huVrg==
X-Received: by 2002:a17:906:8893:: with SMTP id ak19mr1362612ejc.124.1633667116754;
        Thu, 07 Oct 2021 21:25:16 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id e7sm506320edz.95.2021.10.07.21.25.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Oct 2021 21:25:16 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v3 4/8] trace-cmd library: New API to copy buffer description between trace files
Date:   Fri,  8 Oct 2021 07:25:06 +0300
Message-Id: <20211008042510.978362-5-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211008042510.978362-1-tz.stoyanov@gmail.com>
References: <20211008042510.978362-1-tz.stoyanov@gmail.com>
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
index 8ff46d52..4930063e 100644
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
index cde613f3..63a4e7f2 100644
--- a/lib/trace-cmd/trace-input.c
+++ b/lib/trace-cmd/trace-input.c
@@ -4890,6 +4890,19 @@ int tracecmd_copy_headers(struct tracecmd_input *in_handle,
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
2.31.1

