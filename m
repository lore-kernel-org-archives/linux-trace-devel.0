Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-20.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3CE9BC433E0
	for <linux-trace-devel@archiver.kernel.org>; Wed, 23 Dec 2020 04:36:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F2CAC20936
	for <linux-trace-devel@archiver.kernel.org>; Wed, 23 Dec 2020 04:36:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727013AbgLWEfx (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 22 Dec 2020 23:35:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56862 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725300AbgLWEfx (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 22 Dec 2020 23:35:53 -0500
Received: from mail-wr1-x430.google.com (mail-wr1-x430.google.com [IPv6:2a00:1450:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 43AF8C0617A6
        for <linux-trace-devel@vger.kernel.org>; Tue, 22 Dec 2020 20:34:38 -0800 (PST)
Received: by mail-wr1-x430.google.com with SMTP id t16so17342086wra.3
        for <linux-trace-devel@vger.kernel.org>; Tue, 22 Dec 2020 20:34:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=a8kbvUB7yNA5wDS1jH+zjTLod7h9tLFimIPqZVWdYJU=;
        b=WLvX97jGSQubXRd16bJc7yQPjgl8iXNOyKvl+BWvvJARAG3inkGPjL2sD6NoQq/rUv
         6eTaFNbTwC6srf1/zJiyJdj6ug5V4dj4XwxLPrGz7EfWvd04wdidcmYNParSffBKRU7e
         ZpKHnIh1J3pamYO/Xom6HAH6YP1CbTzVPVBKyf7FhxMxp9iuM3lyUyab+CKuR0C/Qmc2
         txcyfzSmjJ0BpnpwijOCmxal9OBWSQ0cmXqRIYVSDfaG+NhdEFb3v3xpssvlUOSGVlbN
         5OdrfrSHiid8BXcIWgxUWo3KXKF0iMksqe0zUbYrfXl7EM1SweZ8OvudRQeHugkqY7lf
         mUmQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=a8kbvUB7yNA5wDS1jH+zjTLod7h9tLFimIPqZVWdYJU=;
        b=slR69NW+VuOjlwGb87WLHSmaJZ1pVUYa01gxyj7qaC8OgWYX+4Wv/VtibgbFWfsCGd
         PIkfBEY6lY0X6D+ig7ZYF8gDbSFfrzM2A6s7LXP33E++FqA2sMDn869i1yF48MiHAu9D
         +u6UEfr1iLxSjfGGYPLjEdiJEXn4CI8v2rUlnnOS1Ch+Hv5/8LHrnodZpIeQrMLhvrFz
         E8oSlofaeIDuRVjwh1+42yK05ou8tYRsN9b5kL9s2ok5t6r/UpukW7m1XSN+XQDU/hOB
         pgZWM2wCw1Fzj7CaIsFVVxhcY+kPdMyJVpJLltWDNUCMX+FjxAWa/6vKna7CY/zmK+GB
         K96w==
X-Gm-Message-State: AOAM532Cisv7K96eUeUYXhXpt9qUzvxX8fvnsT7YPw1PnKNxEjytgwLA
        x9+tW/b63hiH2Rlvf2eedZElDj/4HpXsXBmQ
X-Google-Smtp-Source: ABdhPJyT3bACNcUIz+gm7bs+mGqq/eAIrs1AeuTGwd5w2ZHy+KLw/QNltIOCUDw2FmsNq3IV6LPrqQ==
X-Received: by 2002:a5d:6749:: with SMTP id l9mr27528921wrw.395.1608698076991;
        Tue, 22 Dec 2020 20:34:36 -0800 (PST)
Received: from oberon.vmware.com ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id s13sm28909095wmj.28.2020.12.22.20.34.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Dec 2020 20:34:36 -0800 (PST)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH 5/6] trace-cmd library man pages: Manage trace session with multiple trace peers.
Date:   Wed, 23 Dec 2020 06:34:28 +0200
Message-Id: <20201223043429.586162-6-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201223043429.586162-1-tz.stoyanov@gmail.com>
References: <20201223043429.586162-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Documented APIs:
 tracecmd_pair_peer()
 tracecmd_unpair_peer()
 tracecmd_get_traceid()
 tracecmd_get_guest_cpumap()

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 .../libtracecmd/libtracecmd-peer.3.txt        | 149 ++++++++++++++++++
 1 file changed, 149 insertions(+)
 create mode 100644 Documentation/libtracecmd/libtracecmd-peer.3.txt

diff --git a/Documentation/libtracecmd/libtracecmd-peer.3.txt b/Documentation/libtracecmd/libtracecmd-peer.3.txt
new file mode 100644
index 00000000..af0bf5dc
--- /dev/null
+++ b/Documentation/libtracecmd/libtracecmd-peer.3.txt
@@ -0,0 +1,149 @@
+libtracecmd(3)
+=============
+
+NAME
+----
+tracecmd_pair_peer, tracecmd_unpair_peer, tracecmd_get_traceid,
+tracecmd_get_guest_cpumap - Manage trace session with multiple trace peers,
+recorded in multiple trace files.
+
+SYNOPSIS
+--------
+[verse]
+--
+*#include <trace-cmd.h>*
+
+int *tracecmd_pair_peer*(struct tracecmd_input pass:[*]_handle_, struct tracecmd_input pass:[*]_peer_);
+void *tracecmd_unpair_peer*(struct tracecmd_input pass:[*]_handle_);
+unsigned long long *tracecmd_get_traceid*(struct tracecmd_input pass:[*]_handle_);
+int *tracecmd_get_guest_cpumap*(struct tracecmd_input pass:[*]_handle_, unsigned long long _trace_id_, const char pass:[*]pass:[*]_name_, int pass:[*]_vcpu_count_, const int pass:[*]pass:[*]_cpu_pid_);
+--
+
+DESCRIPTION
+-----------
+This set of APIs can be used to manage trace session with multiple trace
+peers, like in tracing kernels of host and guests machines. The trace data
+of each peer from the session is recorded in separate trace file.
+Information about peers from the session is stored in the metadata of each
+trace file. These APIs use that information to extract and synchronize
+the trace data.
+
+The _tracecmd_pair_peer()_ function pairs two tracecmd_input handlers,
+associated with two trace files from same trace session. This API must
+be called before _tracecmd_init_data()(3)_, as the initialisation of
+the trace data depends on that. If there is a tracing peer, the event
+timestamps are recalculated in order to be in the same time space.
+
+The _tracecmd_unpair_peer()_ function unpairs a peer from _handle_,
+previously paired with _tracecmd_pair_peer()_.
+
+The _tracecmd_get_traceid()_ function returns the trace ID stored in
+trace file metadata, associated with _handle_. Each peer from a trace
+session has an ID unique for that peer and that trace session only.
+This ID is used to match multiple trace files recorded in a same trace
+session.
+
+The _tracecmd_get_guest_cpumap()_ function gets the mapping of guest
+VCPU to the host process, stored in the metadata of the trace file
+associated with _handle_. This information is gathered during a host-guest
+trace session and is stored in host trace file. The _trace_id_ parameter is
+the trace ID of the guest in this particular trace session. If a guest
+with that ID was part of that session, its VCPU to host process mapping
+is in the host trace file and the information is returned in _name_,
+_vcpu_count_ and _cpu_pid_ parameters. In _name_ is returned the name
+of the guest, in _vcpu_count_ is returned the count of VCPUs of that
+guest and in _cpu_pid_ array is returned the VCPU to host process mapping.
+The array is of size _vcpu_count_ where the index is VCPU and the value
+is PID of the host process, running that VCPU. The _name_, _vcpu_count_
+and _cpu_pid_ values must *not* be freed.
+
+RETURN VALUE
+------------
+The _tracecmd_pair_peer()_ function returns 1, if a peer is already
+paired, -1 in case of an error or 0 otherwise.
+
+The tracecmd_get_traceid() function returns a 64 bit trace ID.
+
+The _tracecmd_get_guest_cpumap()_ function returns -1 in case of
+an error or 0 otherwise. If 0 is returned, in the _name_, _vcpu_count_
+and _cpu_pid_ parameters is stored requested information.
+
+EXAMPLE
+-------
+[source,c]
+--
+#include <trace-cmd.h>
+...
+struct tracecmd_input *host = tracecmd_open_head("trace.dat");
+	if (!host) {
+		/* Failed to open host trace file */
+	}
+	tracecmd_init_data(host);
+
+struct tracecmd_input *guest = tracecmd_open_head("trace-Guest.dat");
+	if (!guest) {
+		/* Failed to open guest trace file */
+	}
+
+unsigned long long guest_id = tracecmd_get_traceid(guest);
+int *cpu_pid;
+char *name;
+int vcount;
+
+	if (!tracecmd_get_guest_cpumap(host, guest_id, &name, &vcount, &cpu_pid)) {
+		/* The Host and a guest with name was part of the same trace session.
+		 * Got guest VCPU to host PID mapping.
+		 */
+		if (!tracecmd_pair_peer(guest, host)) {
+			/* Successfully paired host to the guest handler */
+			tracecmd_init_data(guest);
+			...
+			tracecmd_unpair_peer(guest);
+		}
+	}
+
+...
+	tracecmd_close(guest);
+	tracecmd_close(hadle);
+
+--
+FILES
+-----
+[verse]
+--
+*trace-cmd.h*
+	Header file to include in order to have access to the library APIs.
+*-libtracecmd*
+	Linker switch to add when building a program that uses the library.
+--
+
+SEE ALSO
+--------
+_libtracefs(3)_,
+_libtraceevent(3)_,
+_trace-cmd(1)_
+_trace-cmd.dat(5)_
+
+AUTHOR
+------
+[verse]
+--
+*Steven Rostedt* <rostedt@goodmis.org>
+*Tzvetomir Stoyanov* <tz.stoyanov@gmail.com>
+--
+REPORTING BUGS
+--------------
+Report bugs to  <linux-trace-devel@vger.kernel.org>
+
+LICENSE
+-------
+libtracecmd is Free Software licensed under the GNU LGPL 2.1
+
+RESOURCES
+---------
+https://git.kernel.org/pub/scm/utils/trace-cmd/trace-cmd.git/
+
+COPYING
+-------
+Copyright \(C) 2020 VMware, Inc. Free use of this software is granted under
+the terms of the GNU Public License (GPL).
-- 
2.28.0

