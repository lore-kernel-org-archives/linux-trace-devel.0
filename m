Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 56EA1C433EF
	for <linux-trace-devel@archiver.kernel.org>; Fri, 10 Dec 2021 10:54:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236949AbhLJK6a (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 10 Dec 2021 05:58:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34418 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234152AbhLJK6a (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 10 Dec 2021 05:58:30 -0500
Received: from mail-ed1-x533.google.com (mail-ed1-x533.google.com [IPv6:2a00:1450:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 12189C061746
        for <linux-trace-devel@vger.kernel.org>; Fri, 10 Dec 2021 02:54:55 -0800 (PST)
Received: by mail-ed1-x533.google.com with SMTP id x10so11321320edd.5
        for <linux-trace-devel@vger.kernel.org>; Fri, 10 Dec 2021 02:54:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=fhN3EMHUINew41sFoQdsKAmLqqZJau9mu6Q+Il+IlwA=;
        b=KSTx/UVaVuhU/mmuavJi7O5MNFhJIbuTEv6sLCHXjJVHBsB2vRUKSBuaAWZ5uV4Pvy
         +vxc3FmRs+OSO5XbEK3d28U3X3WlTp/Fdu+lfk3jzRF4zkVBvSZMywTCAQxbM/QwbiQo
         hqhoNwcv5L1sarFZDzQ3bJ/LbWciJzRm1Mpi9fGAwRqS8e3aQAfYYEvl4axrxrCGDFQd
         gtX2262dN79+6piuzBUQE5xps02aER4b5rkVUHowIy6O0FBCiBMXgFlY9Cfmzm+pLi+8
         frJsqJ5z6roDXkq2HEX9Lzecqgq6R6LCNOWsrdFxsdVRaYPqY6mCcyYTCo6tDjiNtDVm
         xeBg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=fhN3EMHUINew41sFoQdsKAmLqqZJau9mu6Q+Il+IlwA=;
        b=w1o8qqolClSBc5ySJsEjg5geenb0GKValMMGylwVFD/lNen4Rd9OshtgZbbryT6/k7
         qQzjwKHQvCT7vH4Yr2odtnNEN9f9PE2HR40zG1Vns8LTm54clglDrbMVmzg6BwZT+ebD
         kDmvjBkNbfc9TaldsjdskIcdGdmSI7NaGZlK/7Pl0aD+jw0neF78yvp7/AY+RAtJFwqr
         WVW/35jt7MMOJb6iaJsDhlD2LIJeVVyi0pgjMoGU128EHCf0ZzcPe1955HNHnZyciG+s
         DkEZWNFeCenIgP/0mlC4k5CWgT+EiWtqFQF887TvkjTvBmj8QF1v+K8Bg0OvZ1vbAvrp
         ud5g==
X-Gm-Message-State: AOAM533zR7tJf1dPsXQoRmMRwvdK3Vzh5wm+BvWV/ruaustQ6HPfOTJa
        t3znkB/q/4NS3xN6bl9pAAS45oFtgPE=
X-Google-Smtp-Source: ABdhPJynI89wHNXqCtJ3ufV+71ifaCc/j2qKi6BtPtvXFWijeDx8K6AuRW/GYgZX/z1ud/8tIKc61A==
X-Received: by 2002:a17:907:6e91:: with SMTP id sh17mr23743441ejc.86.1639133693248;
        Fri, 10 Dec 2021 02:54:53 -0800 (PST)
Received: from oberon.zico.biz.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id x7sm1306314edd.28.2021.12.10.02.54.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Dec 2021 02:54:52 -0800 (PST)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v7 03/25] trace-cmd library: New APIs to get and set version of output handler
Date:   Fri, 10 Dec 2021 12:54:26 +0200
Message-Id: <20211210105448.97850-4-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211210105448.97850-1-tz.stoyanov@gmail.com>
References: <20211210105448.97850-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

There are cases where the version of the file, associated with given
output handle must be get or set. Added new APIs for such use cases:
  tracecmd_get_out_file_version()
  tracecmd_output_set_version()

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 .../include/private/trace-cmd-private.h       |  2 ++
 lib/trace-cmd/trace-output.c                  | 28 +++++++++++++++++++
 2 files changed, 30 insertions(+)

diff --git a/lib/trace-cmd/include/private/trace-cmd-private.h b/lib/trace-cmd/include/private/trace-cmd-private.h
index 9ed29e10..ed25d879 100644
--- a/lib/trace-cmd/include/private/trace-cmd-private.h
+++ b/lib/trace-cmd/include/private/trace-cmd-private.h
@@ -280,6 +280,7 @@ int tracecmd_output_set_msg(struct tracecmd_output *handle,
 int tracecmd_output_set_trace_dir(struct tracecmd_output *handle, const char *tracing_dir);
 int tracecmd_output_set_kallsyms(struct tracecmd_output *handle, const char *kallsyms);
 int tracecmd_output_set_from_input(struct tracecmd_output *handle, struct tracecmd_input *ihandle);
+int tracecmd_output_set_version(struct tracecmd_output *handle, int file_version);
 int tracecmd_output_write_headers(struct tracecmd_output *handle,
 				  struct tracecmd_event_list *list);
 
@@ -313,6 +314,7 @@ int tracecmd_append_cpu_data(struct tracecmd_output *handle,
 int tracecmd_append_buffer_cpu_data(struct tracecmd_output *handle,
 				    const char *name, int cpus, char * const *cpu_data_files);
 struct tracecmd_output *tracecmd_get_output_handle_fd(int fd);
+unsigned long tracecmd_get_out_file_version(struct tracecmd_output *handle);
 
 /* --- Reading the Fly Recorder Trace --- */
 
diff --git a/lib/trace-cmd/trace-output.c b/lib/trace-cmd/trace-output.c
index 6ed4bbf0..4d165ac2 100644
--- a/lib/trace-cmd/trace-output.c
+++ b/lib/trace-cmd/trace-output.c
@@ -1065,6 +1065,25 @@ int tracecmd_output_set_from_input(struct tracecmd_output *handle, struct tracec
 	return 0;
 }
 
+/**
+ * tracecmd_output_set_version - Set file version of the output handle
+ * @handle: output handle to a trace file.
+ * @file_version: desired file version
+ *
+ * This API must be called before tracecmd_output_write_headers().
+ *
+ * Returns 0 on success, or -1 if the output file handle is not allocated or not in expected state.
+ */
+int tracecmd_output_set_version(struct tracecmd_output *handle, int file_version)
+{
+	if (!handle || handle->file_state != TRACECMD_FILE_ALLOCATED)
+		return -1;
+	if (file_version < FILE_VERSION_MIN || file_version > FILE_VERSION_MAX)
+		return -1;
+	handle->file_version = file_version;
+	return 0;
+}
+
 /**
  * output_write_init - Write the initial data into the trace file
  * @handle: output handle to a trace file.
@@ -1880,3 +1899,12 @@ __hidden bool check_out_state(struct tracecmd_output *handle, int new_state)
 {
 	return check_file_state(handle->file_version, handle->file_state, new_state);
 }
+
+/**
+ * tracecmd_get_out_file_version - return the trace.dat file version
+ * @handle: output handle for the trace.dat file
+ */
+unsigned long tracecmd_get_out_file_version(struct tracecmd_output *handle)
+{
+	return handle->file_version;
+}
-- 
2.33.1

