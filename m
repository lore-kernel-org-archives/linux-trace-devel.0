Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-19.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 97C25C4708F
	for <linux-trace-devel@archiver.kernel.org>; Wed,  2 Jun 2021 09:08:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7E625613AE
	for <linux-trace-devel@archiver.kernel.org>; Wed,  2 Jun 2021 09:08:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229754AbhFBJJz (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 2 Jun 2021 05:09:55 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:48321 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229620AbhFBJJy (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 2 Jun 2021 05:09:54 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1622624892;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=QM01IMgINbaoMvTxCd149lZb3T2/GCadBJHVRGQ6esU=;
        b=WKim1JA20tGKx5YEObiD0sawnvor5OStPa0cuNirHM4E15IX7dMjAYRXbFSy1DVhuO1o2g
        HqRz1xv580NLua8yYTIqnBX7qCBLsML3TKtz8Qhm4V7cCBwlw7Q5NaclFPS+jr3LmXqI5X
        Lf+3hGND8Wwv0zhIFRS3lDN7EnP6ZtU=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-478-nmsQV-EWNLqlg036P24BnA-1; Wed, 02 Jun 2021 05:08:08 -0400
X-MC-Unique: nmsQV-EWNLqlg036P24BnA-1
Received: by mail-wm1-f70.google.com with SMTP id v20-20020a05600c2154b029019a6368bfe4so387974wml.2
        for <linux-trace-devel@vger.kernel.org>; Wed, 02 Jun 2021 02:08:08 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=QM01IMgINbaoMvTxCd149lZb3T2/GCadBJHVRGQ6esU=;
        b=Myl9ectoF9zN0jkh/4dIEZTkC37MsjNn5+M+OgzlEdCU32FjxH3vSWdedV0rLN5ysY
         xSZi399zAf99V3v009jD81KMx+6gDZO22WFwV7R+XOOpntBpe/aWP6/HWlxlkWyERVZi
         KprVVww8jaT/vNFlyBMvXa00HbU8DyYllvR1fFe25SfLTrqOaQO0uOYrSZb1e9yFqxuP
         zNeyJ5tA9DbiS6tx+1yM55D3FMhafgftiqVYs4v05qw2orL/F4Ynvxbl43b7DJaOC12A
         GBMFgRYniY2/8u9jsigm6su/WQsdh9oQKWaL31u/ocquXdrUbScj/YGmW05IKNYm0x1H
         +Wpw==
X-Gm-Message-State: AOAM5301b5zWfTAIoRiBpAtOlNShmEecYWD7usplcZkUktNoz++Mesfz
        Xy4I6WynDWd9t7JtfLfaoDdMFIQCnYltucGvrJsZ5rnV1mOZDKCf2HiLk4/+xxwI0Gm/jmjg/81
        wCG5TQtfu907SgJ8dUSWfYUzCjtYXi7o13xlHHC04UhIcQAF+29CZeWiQXEmClWtm83SX0CX3ng
        ZmYyLGnJ8=
X-Received: by 2002:a05:6000:2c4:: with SMTP id o4mr765638wry.267.1622624887389;
        Wed, 02 Jun 2021 02:08:07 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyhZcB7obiUXsglReFgOCyc8BmaMLpn8KJ4cphuDU2pT1OpqSNIMn99IcFjpKPitOKvWhdB0g==
X-Received: by 2002:a05:6000:2c4:: with SMTP id o4mr765609wry.267.1622624887143;
        Wed, 02 Jun 2021 02:08:07 -0700 (PDT)
Received: from vian.redhat.com ([2a0c:5a80:3d14:2800:933d:abfc:d8e4:637f])
        by smtp.gmail.com with ESMTPSA id d8sm5482264wro.16.2021.06.02.02.08.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Jun 2021 02:08:06 -0700 (PDT)
From:   Nicolas Saenz Julienne <nsaenzju@redhat.com>
To:     linux-trace-devel@vger.kernel.org
Cc:     rostedt@goodmis.org, Nicolas Saenz Julienne <nsaenzju@redhat.com>
Subject: [PATCH] trace-cmd: Add option to poll trace buffers
Date:   Wed,  2 Jun 2021 11:08:03 +0200
Message-Id: <20210602090803.12233-1-nsaenzju@redhat.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Waiting for data to be available on the trace ring-buffers may trigger
IPIs. This might generate unacceptable trace noise when debugging low
latency or real time systems. So introduce the poll option. When
enabled, it forces trace-cmd to use O_NONBLOCK. The drawback to using it
is that traces will be extracted by busy waiting, which will
unnecessarily hog the CPUs, so only use when really needed.

Signed-off-by: Nicolas Saenz Julienne <nsaenzju@redhat.com>

---

NOTE: I'm aware that TRACECMD_RECORD_POLL kind of clashes with
      TRACECMD_RECORD_BLOCK. That's why I renamed it. There might be a
      clean way to merge them into a single flag, but it's not clear to
      me why was TRACECMD_RECORD_BLOCK needed in the first place (since
      it only affects splicing).

 .../trace-cmd/trace-cmd-record.1.txt          |  7 +++++
 .../include/private/trace-cmd-private.h       |  3 +-
 lib/trace-cmd/trace-recorder.c                | 29 ++++++++++---------
 tracecmd/trace-record.c                       |  8 ++++-
 tracecmd/trace-usage.c                        |  1 +
 5 files changed, 33 insertions(+), 15 deletions(-)

diff --git a/Documentation/trace-cmd/trace-cmd-record.1.txt b/Documentation/trace-cmd/trace-cmd-record.1.txt
index 55a8891..5d063cc 100644
--- a/Documentation/trace-cmd/trace-cmd-record.1.txt
+++ b/Documentation/trace-cmd/trace-cmd-record.1.txt
@@ -360,6 +360,13 @@ OPTIONS
     executed will not be changed. This is useful if you want to monitor the
     output of the command being executed, but not see the output from trace-cmd.
 
+*--poll*::
+    Waiting for data to be available on the trace ring-buffers may trigger
+    IPIs. This might generate unacceptable trace noise when tracing low latency
+    or real time systems. The poll option forces trace-cmd to use O_NONBLOCK.
+    Traces are extracted by busy waiting, which will hog the CPUs, so only use
+    when really needed.
+
 EXAMPLES
 --------
 
diff --git a/lib/trace-cmd/include/private/trace-cmd-private.h b/lib/trace-cmd/include/private/trace-cmd-private.h
index 42e739f..5c2ab4c 100644
--- a/lib/trace-cmd/include/private/trace-cmd-private.h
+++ b/lib/trace-cmd/include/private/trace-cmd-private.h
@@ -319,8 +319,9 @@ struct tracecmd_output *tracecmd_get_output_handle_fd(int fd);
 enum {
 	TRACECMD_RECORD_NOSPLICE	= (1 << 0),	/* Use read instead of splice */
 	TRACECMD_RECORD_SNAPSHOT	= (1 << 1),	/* Extract from snapshot */
-	TRACECMD_RECORD_BLOCK		= (1 << 2),	/* Block on splice write */
+	TRACECMD_RECORD_BLOCK_SPLICE	= (1 << 2),	/* Block on splice write */
 	TRACECMD_RECORD_NOBRASS		= (1 << 3),	/* Splice directly without a brass pipe */
+	TRACECMD_RECORD_POLL		= (1 << 4),	/* Use O_NONBLOCK, poll trace buffers */
 };
 
 void tracecmd_free_recorder(struct tracecmd_recorder *recorder);
diff --git a/lib/trace-cmd/trace-recorder.c b/lib/trace-cmd/trace-recorder.c
index 0caa124..c833378 100644
--- a/lib/trace-cmd/trace-recorder.c
+++ b/lib/trace-cmd/trace-recorder.c
@@ -112,6 +112,18 @@ void tracecmd_free_recorder(struct tracecmd_recorder *recorder)
 	free(recorder);
 }
 
+static void set_nonblock(struct tracecmd_recorder *recorder)
+{
+	long flags;
+
+	/* Do not block on reads */
+	flags = fcntl(recorder->trace_fd, F_GETFL);
+	fcntl(recorder->trace_fd, F_SETFL, flags | O_NONBLOCK);
+
+	/* Do not block on streams */
+	recorder->fd_flags |= SPLICE_F_NONBLOCK;
+}
+
 struct tracecmd_recorder *
 tracecmd_create_buffer_recorder_fd2(int fd, int fd2, int cpu, unsigned flags,
 				    const char *buffer, int maxkb)
@@ -130,7 +142,7 @@ tracecmd_create_buffer_recorder_fd2(int fd, int fd2, int cpu, unsigned flags,
 
 	recorder->fd_flags = SPLICE_F_MOVE;
 
-	if (!(recorder->flags & TRACECMD_RECORD_BLOCK))
+	if (!(recorder->flags & TRACECMD_RECORD_BLOCK_SPLICE))
 		recorder->fd_flags |= SPLICE_F_NONBLOCK;
 
 	recorder->trace_fd_flags = SPLICE_F_MOVE;
@@ -198,6 +210,9 @@ tracecmd_create_buffer_recorder_fd2(int fd, int fd2, int cpu, unsigned flags,
 		recorder->pipe_size = pipe_size;
 	}
 
+	if (recorder->flags & TRACECMD_RECORD_POLL)
+		set_nonblock(recorder);
+
 	return recorder;
 
  out_free:
@@ -504,18 +519,6 @@ static long move_data(struct tracecmd_recorder *recorder)
 	return splice_data(recorder);
 }
 
-static void set_nonblock(struct tracecmd_recorder *recorder)
-{
-	long flags;
-
-	/* Do not block on reads for flushing */
-	flags = fcntl(recorder->trace_fd, F_GETFL);
-	fcntl(recorder->trace_fd, F_SETFL, flags | O_NONBLOCK);
-
-	/* Do not block on streams for write */
-	recorder->fd_flags |= SPLICE_F_NONBLOCK;
-}
-
 long tracecmd_flush_recording(struct tracecmd_recorder *recorder)
 {
 	char buf[recorder->page_size];
diff --git a/tracecmd/trace-record.c b/tracecmd/trace-record.c
index bf91189..60ee5fb 100644
--- a/tracecmd/trace-record.c
+++ b/tracecmd/trace-record.c
@@ -3333,7 +3333,7 @@ create_recorder_instance_pipe(struct buffer_instance *instance,
 			      int cpu, int *brass)
 {
 	struct tracecmd_recorder *recorder;
-	unsigned flags = recorder_flags | TRACECMD_RECORD_BLOCK;
+	unsigned flags = recorder_flags | TRACECMD_RECORD_BLOCK_SPLICE;
 	char *path;
 
 	path = tracefs_instance_get_dir(instance->tracefs);
@@ -5757,6 +5757,7 @@ enum {
 	OPT_module		= 256,
 	OPT_nofifos		= 257,
 	OPT_cmdlines_size	= 258,
+	OPT_poll		= 259,
 };
 
 void trace_stop(int argc, char **argv)
@@ -6172,6 +6173,7 @@ static void parse_record_options(int argc,
 			{"tsync-interval", required_argument, NULL, OPT_tsyncinterval},
 			{"fork", no_argument, NULL, OPT_fork},
 			{"tsc2nsec", no_argument, NULL, OPT_tsc2nsec},
+			{"poll", no_argument, NULL, OPT_poll},
 			{NULL, 0, NULL, 0}
 		};
 
@@ -6593,6 +6595,10 @@ static void parse_record_options(int argc,
 				die("TSC to nanosecond is not supported");
 			ctx->instance->flags |= BUFFER_FL_TSC2NSEC;
 			break;
+		case OPT_poll:
+			cmd_check_die(ctx, CMD_set, *(argv+1), "--poll");
+			recorder_flags |= TRACECMD_RECORD_POLL;
+			break;
 		case OPT_quiet:
 		case 'q':
 			quiet = true;
diff --git a/tracecmd/trace-usage.c b/tracecmd/trace-usage.c
index 998f5a2..c0033ce 100644
--- a/tracecmd/trace-usage.c
+++ b/tracecmd/trace-usage.c
@@ -68,6 +68,7 @@ static struct usage_help usage_help[] = {
 		"               If a negative number is specified, timestamps synchronization is disabled"
 		"               If 0 is specified, no loop is performed - timestamps offset is calculated only twice,"
 		"                                                         at the beginnig and at the end of the trace\n"
+		"          --poll don't block while reading from the trace buffer\n"
 	},
 	{
 		"set",
-- 
2.31.1

