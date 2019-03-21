Return-Path: <SRS0=gVBF=RY=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D2CEFC43381
	for <linux-trace-devel@archiver.kernel.org>; Thu, 21 Mar 2019 20:52:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A3ACC218A5
	for <linux-trace-devel@archiver.kernel.org>; Thu, 21 Mar 2019 20:52:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726533AbfCUUwg (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 21 Mar 2019 16:52:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:42846 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726460AbfCUUwg (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 21 Mar 2019 16:52:36 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 650D521874;
        Thu, 21 Mar 2019 20:52:35 +0000 (UTC)
Date:   Thu, 21 Mar 2019 16:52:33 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Tzvetomir Stoyanov <tstoyanov@vmware.com>
Cc:     Matt Helsley <mhelsley@vmware.com>,
        "linux-trace-devel@vger.kernel.org" 
        <linux-trace-devel@vger.kernel.org>
Subject: Re: [PATCH v7 5/9] trace-cmd: Refactored few functions in
 trace-record.c
Message-ID: <20190321165233.143ea97d@gandalf.local.home>
In-Reply-To: <CACqStoev5pRXxH64auUFkfwJ4sUG0hdQ6Uz8cQ9qphZJQK-qPw@mail.gmail.com>
References: <20190319155536.19381-1-tstoyanov@vmware.com>
        <20190319155536.19381-6-tstoyanov@vmware.com>
        <0FEA60D5-2542-498E-A494-C15B0B2AE0A4@vmware.com>
        <CACqStodWOOPAi0Y36Xp5u=Ny0e+acmys=HUV4qxLB+3sqeAPBw@mail.gmail.com>
        <20190320103513.40d67e38@gandalf.local.home>
        <CACqStoev5pRXxH64auUFkfwJ4sUG0hdQ6Uz8cQ9qphZJQK-qPw@mail.gmail.com>
X-Mailer: Claws Mail 3.16.0 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Thu, 21 Mar 2019 15:06:03 +0000
Tzvetomir Stoyanov <tstoyanov@vmware.com> wrote:

> #!/bin/bash
> 
> INST_NAME=vtest
> TRACE_INST_DIR=/sys/kernel/debug/tracing/instances
> 
> mkdir $TRACE_INST_DIR/$INST_NAME
> 
> echo "vmx_read_l1_tsc_offset" > $TRACE_INST_DIR/$INST_NAME/set_ftrace_filter
> echo "function" > $TRACE_INST_DIR/$INST_NAME/current_tracer
> echo "1" > $TRACE_INST_DIR/$INST_NAME/events/vsock/virtio_transport_recv_pkt/enable
> echo "len!=0" > $TRACE_INST_DIR/$INST_NAME/events/vsock/virtio_transport_recv_pkt/filter
> echo "mono_raw" > $TRACE_INST_DIR/$INST_NAME/trace_clock
> echo "1" > $TRACE_INST_DIR/$INST_NAME/tracing_on
> 
> sleep 2
> 
> echo "0" > $TRACE_INST_DIR/$INST_NAME/tracing_on
> echo "" > $TRACE_INST_DIR/$INST_NAME/set_ftrace_filter
> echo "nop" > $TRACE_INST_DIR/$INST_NAME/current_tracer
> echo "0" > $TRACE_INST_DIR/$INST_NAME/events/vsock/virtio_transport_recv_pkt/enable
> echo '0' > $TRACE_INST_DIR/$INST_NAME/events/vsock/virtio_transport_recv_pkt/filter
> echo "local" > $TRACE_INST_DIR/$INST_NAME/trace_clock
> 
> rm -rf $TRACE_INST_DIR/$INST_NAME

Ah, that's because you are trying to remove the individual files. These
are not real files, and can not be removed. But you can remove the
directory.

 rmdir $TRACE_INST_DIR/$INST_NAME

works as expected.

-- Steve
