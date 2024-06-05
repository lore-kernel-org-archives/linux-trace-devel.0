Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B13341953AF
	for <linux-trace-devel@vger.kernel.org>; Wed,  5 Jun 2024 13:41:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717594863; cv=none; b=h5TkyeJIM0yzeqvsvJ1a7rYMzzZXLDSHAP391CER/LSZ7Vg5xSFil+uUAYGtn9QGWv+wI4GhN1kx3EPTOG5N+4VYwVwXjy51MFr3chaP/WE8Z9qf55sM9SWE/8LtTocXuwmrsup+dNHqgBs0FSncblCNL8Fu1lEocSPn8cZZrYw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717594863; c=relaxed/simple;
	bh=UlZcSAJZFeO7Z8IdT4uEHVqNS9PrGQOb3JPVGF3k704=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=tLS8HwHpM63jWTUuw+6ULWUZpAfFQIo56PYjKnIMZuNr0rgnmBUvH1wfKzVFdmqllLgkj1IcRIphykD1T9c/ZX78Me9yypNdXcWI3cGe8IMnN8iyUkYEmt9HGDHp6Pxry/PgW6mb/w2rfyshsxwtHnOT3Mb56Ypa3zdcb/uYx5Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=OtXRdH8s; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="OtXRdH8s"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1717594860;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=UQoIUb5Bv/nNV7ZH30392AjSZ2ceyQ6NMK+zX1IdfOk=;
	b=OtXRdH8sys2LnM9nmk5Y9yjOhaIkcGzL5nE48xDXulFSuC81SxodSAPcZaGtMxVs+WmxDi
	U9hG22OFdTBx7EvyvHrivAYxb74jqlccR2gIWZOLbtSMAvM6W6tqxnvcR6hXdW0UX1yFsN
	WAFn8qBzDAOxZbtTszhoyMNn34aeApI=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-398-lhd3ol_xOziokQl03Vbe0g-1; Wed,
 05 Jun 2024 09:40:59 -0400
X-MC-Unique: lhd3ol_xOziokQl03Vbe0g-1
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 17B601955D7E;
	Wed,  5 Jun 2024 13:40:58 +0000 (UTC)
Received: from fedora (unknown [10.45.225.116])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with SMTP id 90F831955F79;
	Wed,  5 Jun 2024 13:40:55 +0000 (UTC)
Received: by fedora (sSMTP sendmail emulation); Wed, 05 Jun 2024 15:40:54 +0200
From: "Jerome Marchand" <jmarchan@redhat.com>
To: Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Cc: Steven Rostedt <rostedt@goodmis.org>,
	Jerome Marchand <jmarchan@redhat.com>
Subject: [PATCH 00/38] trace-cmd: fix misc issues found by static analysis
Date: Wed,  5 Jun 2024 15:40:15 +0200
Message-ID: <20240605134054.2626953-1-jmarchan@redhat.com>
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17

A number of issues were found by running static analysers on the code
of trace-cmd with openscanhub[1]. Mostly ressource leak, but some are
more serious like memory corruption.

[1] https://fedoraproject.org/wiki/OpenScanHub

Jerome Marchand (38):
  trace-cmd listen: close ofd before exiting process_client()
  trace-cmd msg: prevent a memory leak in get_trace_req_args()
  trace-cmd lib: prevent a memory leak in read_header_files()
  trace-cmd: call dlclose() in the error path of load_plugin()
  trace-cmd lib: prevent possible memory coruption in add_plugin_file()
  trace-cmd lib: prevent a memory leak in handle_options()
  trace-cmd lib: prevent a memory leak in regex_event_buf()
  trace-cmd lib: prevent a memory leak in create_event_list_item()
  trace-cmd lib: prevent a memory leak in read_ftrace_printk()
  trace-cmd: don't print a NULL string in append_pid_filter()
  trace-cmd record: prevent possible memory coruption in
    get_pid_addr_maps()
  trace-cmd hist: close tracecmd handle when trace_hist() exits early
  trace-cmd record: prevent a memory leak in show_error()
  trace-cmd record: prevent memory leak in update_pid_filters()
  trace-cmd lib: check the return value of do_lssek() in
    trace_get_options()
  trace-cmd lib: don't double close a file descriptor in
    read_header_files()
  trace-cmd lib: prevent memory leak in ptp_clock_server()
  trace-cmd lib: remove useless code in tracecmd_plog()
  trace-cmd record: prevent memory leak in add_all_instances()
  trace-cmd lib: check for a negative return value of read in
    tracecmd_compress_copy_from()
  trace-cmd record: prevent memory leak in clear_func_filter()
  trace-cmd dump: prevent buffer overrun in dump_clock()
  trace-cmd lib: prevent buffer overrun in read_string()
  trace-cmd: close file descriptor in trace_vsock_make()
  trace-cmd lib: prevent memory leak in glob_events()
  trace-cmd record: don't print a NULL string in get_temp_file()
  trace-cmd lib: prevent a possible file descriptor leak in
    set_proc_kptr_restrict()
  trace-cmd lib: remove unused tracecmd_parse_cmdlines() function
  trace-cmd record: prevent memory leak in setup_network()
  trace-cmd listen: prevent memory leak in communicate_with_client()
  trace-cmd listen: prevent a infinite loop in communicate_with_client()
  trace-cmd lib: prevent memory leak in tracecmd_create_event_hook()
  trace-cmd record: prevent memory corruption in parse_record_options()
  trace-cmd mem: prevent a memory leak in trace_mem()
  trace-cmd: move the initialization of found_pid at the beginning of
    stop_trace_connect()
  trace-cmd record: check the length of the protocol version received
  trace-cmd record: close socket fd before retrying to connect
  trace-cmd lib: prevent a memory leak in tracecmd_tsync_proto_getall()

 lib/trace-cmd/trace-compress.c     |  4 +--
 lib/trace-cmd/trace-hooks.c        |  1 +
 lib/trace-cmd/trace-input.c        | 17 +++++++------
 lib/trace-cmd/trace-msg.c          | 13 ++--------
 lib/trace-cmd/trace-output.c       | 39 +++++++++++++++++++-----------
 lib/trace-cmd/trace-plugin.c       |  8 +++---
 lib/trace-cmd/trace-timesync-ptp.c |  4 ++-
 lib/trace-cmd/trace-timesync.c     |  2 +-
 lib/trace-cmd/trace-util.c         | 26 ++------------------
 tracecmd/trace-dump.c              |  2 +-
 tracecmd/trace-hist.c              |  4 ++-
 tracecmd/trace-listen.c            | 13 +++++++---
 tracecmd/trace-mem.c               |  3 ++-
 tracecmd/trace-read.c              |  2 +-
 tracecmd/trace-record.c            | 19 +++++++++++----
 tracecmd/trace-vm.c                |  2 +-
 tracecmd/trace-vsock.c             |  8 ++++--
 17 files changed, 87 insertions(+), 80 deletions(-)

-- 
2.44.0

