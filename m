Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 59A93C63682
	for <linux-trace-devel@archiver.kernel.org>; Wed, 26 Jan 2022 09:52:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232828AbiAZJwE (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 26 Jan 2022 04:52:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49434 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229663AbiAZJwE (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 26 Jan 2022 04:52:04 -0500
Received: from mail-ed1-x534.google.com (mail-ed1-x534.google.com [IPv6:2a00:1450:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5850CC06161C
        for <linux-trace-devel@vger.kernel.org>; Wed, 26 Jan 2022 01:52:03 -0800 (PST)
Received: by mail-ed1-x534.google.com with SMTP id j23so63028341edp.5
        for <linux-trace-devel@vger.kernel.org>; Wed, 26 Jan 2022 01:52:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=gpBCiaTu4bIKCouWw2H9YKfJ0QpTsb3puj4jgwBl9HE=;
        b=mv9TkacVg6N5QEQLxbp3ENeqMcHxqvRsCKic1/2oXDKw04ieD9yn5gqR0gnuXG+Jfu
         HbFjwBSAQCDafi0nU/kBBWIwmz0VTsaFqhod20zIe+NUuACth9iX8P4jdpkTmEgf5d1g
         MNoDexZ4Fk4SacqkU6DdZwonqxTttN7iof/W6Vb4N34MuHWHI1noON66AC36l2sBeC33
         OrrfX/heN/Z6TLSxc3zDCnXRrhbgmlC+y0MyuOoY1y4byXICZTRQH+oGjNO9D8ebZeM1
         Sspm3MqT6buGnD3TYqxf+RkDtqZI0WMLrJ4V3qBotfZ+qr8uI0LWirgfHGLcQba+wt+O
         m/hA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=gpBCiaTu4bIKCouWw2H9YKfJ0QpTsb3puj4jgwBl9HE=;
        b=Ko/Rk+M1MzVFn5aYqopshwppBThxIbJAHDTC2clVgclg5h+9ResqTAwRBboRzYM60V
         NGTvtlYoLuvmBmMVtWM4JCcmLTCs/vU7KgwSVmAN5ZaXZokcD6Fmfu6oYmVlpZEwtQsg
         oGJURr+V+0qJ3CHhpI6rZHXcf/i9v6h2insca3+FO6HHUOXCReW5LJbs6pr7rYoqKhB2
         eeQ6ZlXDsaOVa8FnegD87W+ffkZTX2JqNcUzLy95/sVS/vPvzKjc/fPhxQcODf3i3A6J
         OAo/286Ge3eQwgEuv/1BJZ/tZbcCulo3OHt//ugxGAWxIYQyKTrRFgXAuCTK52DrZ46k
         tzZA==
X-Gm-Message-State: AOAM530LO2NaXJk4lkGDVYuHzqTwtqXl03bR8bzUdjgB3Cu28jVDbS7k
        GvLz/P4d8Yqtu9ogucuimK7ZKJSnQwo=
X-Google-Smtp-Source: ABdhPJxHsE2NXfHo7ZgeU2jOpNxcO8GrwZ4lPYNqUTUZu8VV3oqfljjvIxN5RrLSRVvyMfRfNbTQSg==
X-Received: by 2002:a05:6402:1d4a:: with SMTP id dz10mr24151813edb.206.1643190721930;
        Wed, 26 Jan 2022 01:52:01 -0800 (PST)
Received: from oberon.zico.biz ([151.251.254.11])
        by smtp.gmail.com with ESMTPSA id v15sm9529823edq.35.2022.01.26.01.52.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 Jan 2022 01:52:01 -0800 (PST)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v8 3/9] trace-cmd library: Copy CPU count between trace files
Date:   Wed, 26 Jan 2022 11:51:48 +0200
Message-Id: <20220126095154.570700-4-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220126095154.570700-1-tz.stoyanov@gmail.com>
References: <20220126095154.570700-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

The tracecmd_copy_headers() API should be able to copy CPU count also,
as it is part of the headers.

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 lib/trace-cmd/trace-input.c | 42 +++++++++++++++++++++++++++++++++++++
 1 file changed, 42 insertions(+)

diff --git a/lib/trace-cmd/trace-input.c b/lib/trace-cmd/trace-input.c
index 09888b35..9afc6559 100644
--- a/lib/trace-cmd/trace-input.c
+++ b/lib/trace-cmd/trace-input.c
@@ -4861,6 +4861,35 @@ error:
 	return -1;
 }
 
+static int copy_cpu_count(struct tracecmd_input *in_handle, struct tracecmd_output *out_handle)
+{
+	unsigned int cpus;
+
+	if (!check_in_state(in_handle, TRACECMD_FILE_CPU_COUNT) ||
+	    !check_out_state(out_handle, TRACECMD_FILE_CPU_COUNT))
+		return -1;
+
+	if (!HAS_SECTIONS(in_handle)) {
+		if (read4(in_handle, &cpus))
+			return -1;
+	} else {
+		cpus = in_handle->max_cpu;
+	}
+
+	if (tracecmd_get_out_file_version(out_handle) < FILE_VERSION_SECTIONS) {
+		cpus = tep_read_number(in_handle->pevent, &cpus, 4);
+		if (do_write_check(out_handle, &cpus, 4))
+			return -1;
+	} else {
+		tracecmd_add_option(out_handle, TRACECMD_OPTION_CPUCOUNT, sizeof(int), &cpus);
+	}
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
@@ -4959,6 +4988,19 @@ int tracecmd_copy_headers(struct tracecmd_input *in_handle,
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
-- 
2.34.1

