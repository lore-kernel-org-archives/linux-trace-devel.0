Return-Path: <SRS0=WSgK=RP=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F3F20C43381
	for <linux-trace-devel@archiver.kernel.org>; Tue, 12 Mar 2019 19:18:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BC796214AE
	for <linux-trace-devel@archiver.kernel.org>; Tue, 12 Mar 2019 19:18:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727273AbfCLTSY (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 12 Mar 2019 15:18:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:56276 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726501AbfCLTSY (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 12 Mar 2019 15:18:24 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 431852077B;
        Tue, 12 Mar 2019 19:18:23 +0000 (UTC)
Date:   Tue, 12 Mar 2019 15:18:20 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Slavomir Kaslev <kaslevs@vmware.com>
Cc:     "linux-trace-devel@vger.kernel.org" 
        <linux-trace-devel@vger.kernel.org>
Subject: Re: [RFC PATCH v8 05/13] trace-cmd: Add TRACE_REQ and TRACE_RESP
 messages
Message-ID: <20190312151820.0547923b@gandalf.local.home>
In-Reply-To: <CAE0o1NtQE_Uux++2TRD0G+B4BY09Cwr6-qa84r4Dt3Os-hzyDw@mail.gmail.com>
References: <20190222180539.27439-1-kaslevs@vmware.com>
        <20190222180539.27439-6-kaslevs@vmware.com>
        <20190222160929.776ac227@gandalf.local.home>
        <CAE0o1NtQE_Uux++2TRD0G+B4BY09Cwr6-qa84r4Dt3Os-hzyDw@mail.gmail.com>
X-Mailer: Claws Mail 3.16.0 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Tue, 12 Mar 2019 18:48:29 +0000
Slavomir Kaslev <kaslevs@vmware.com> wrote:


> > We could send:
> >  int argc =  6;
> >  char **argv = { "4096", "16", "33445", "33446", "33448", "33449" };
> >
> > Or, if you are not comfortable with sending ASCII and converting, what
> > about have a specific "sending an array of numbers"?
> >
> >  int argc = 6;
> >  int *argv = { 4096, 16, 33445, 33446, 33448, 33449 };
> >
> > Thoughts?  
> 
> I don't see any drawbacks of this approach (modulo a bit of
> arithmetic). I implemented it the way it is following how the listener
> is sending port numbers back to the recording process.
> 
> Should we also switch the listener to use the same encoding of ports
> with protocol V3 before the next release?

Yeah, I think we can do that.

> 
> How about options (which is the only other non-text use of the
> variable buffer part of messages)? Currently the only option in use is
> MSGOPT_USETCP and can become simply "tcp" on the wire.
> 
> We can then have a convention that the buffer at then end of messages
> is always text and drop the second union in tracecmd_msg.
> 

Sure.

Do you think there's any use to keeping the "flags" field for the args?

I was thinking that we should rename trace_req to trace_args and add a
"type" field that can be used to verify the type of arguments being
sent. 

enum {
	TRACE_ARGS_PORTS	= 1,
	TRACE_ARGS_OPTIONS,
	TRACE_ARGS_ETC,
	[...]
};

struct tracecmd_msg_trace_args {
	be32		type;
	be32		argc;
};

That way the type will define the arguments being sent, and the
other side will know what is expected of the args, and even test to
make sure they make sense.

-- Steve
