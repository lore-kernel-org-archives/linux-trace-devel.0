Return-Path: <SRS0=k/vv=SO=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A1BB6C10F0E
	for <linux-trace-devel@archiver.kernel.org>; Fri, 12 Apr 2019 18:40:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 73B3220818
	for <linux-trace-devel@archiver.kernel.org>; Fri, 12 Apr 2019 18:40:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726755AbfDLSkC (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 12 Apr 2019 14:40:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:52314 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726711AbfDLSkC (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 12 Apr 2019 14:40:02 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 053B420663;
        Fri, 12 Apr 2019 18:40:00 +0000 (UTC)
Date:   Fri, 12 Apr 2019 14:39:58 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Phil Auld <pauld@redhat.com>
Cc:     linux-trace-devel@vger.kernel.org,
        Yordan Karadzhov <ykaradzhov@vmware.com>,
        Josef Bacik <jbacik@fb.com>,
        Tzvetomir Stoyanov <tstoyanov@vmware.com>,
        Slavomir Kaslev <kaslevs@vmware.com>
Subject: Re: trace-cmd fails with many cpus
Message-ID: <20190412143958.5a5af3eb@gandalf.local.home>
In-Reply-To: <20190412181313.GA11355@lorien.usersys.redhat.com>
References: <20190412135333.GB6201@pauld.bos.csb>
        <20190412111546.0c54576e@gandalf.local.home>
        <20190412113547.31b08902@gandalf.local.home>
        <20190412181313.GA11355@lorien.usersys.redhat.com>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Fri, 12 Apr 2019 14:13:13 -0400
Phil Auld <pauld@redhat.com> wrote:


> I can just find a smaller machine.
> 

Or apply this hack ;-)

-- Steve

diff --git a/tracecmd/trace-record.c b/tracecmd/trace-record.c
index 76ca92dc..fe300401 100644
--- a/tracecmd/trace-record.c
+++ b/tracecmd/trace-record.c
@@ -2988,8 +2988,10 @@ void start_threads(enum trace_type type, struct common_record_context *ctx)
 			pid = pids[i++].pid = create_recorder(instance, x, type, brass);
 			if (brass)
 				close(brass[1]);
+#if 0
 			if (pid > 0)
 				add_filter_pid(pid, 1);
+#endif
 		}
 	}
 	recorder_threads = i;
