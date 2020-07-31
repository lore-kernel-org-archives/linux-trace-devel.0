Return-Path: <SRS0=sIWI=BK=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.6 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CC3D5C433DF
	for <linux-trace-devel@archiver.kernel.org>; Fri, 31 Jul 2020 12:04:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A5E3B22B40
	for <linux-trace-devel@archiver.kernel.org>; Fri, 31 Jul 2020 12:04:15 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="bcUlM4Y7"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732775AbgGaMEP (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 31 Jul 2020 08:04:15 -0400
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:21924 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1732774AbgGaMEP (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 31 Jul 2020 08:04:15 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1596197053;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=n6UIik3Jpq1xXTWaX2y8qVUYtIw2s9+k7YboRf56zbc=;
        b=bcUlM4Y7bHwARj1jqW00AgoQMIMiwvxE40AHIlWf+RzQf/li5hPgp+zwtRjTnDMjeZ9VDG
        VsNpMrujV/IeA3Hos9/31ZDyU2DUHAtEXFNrzqpXnVctV4zfLTA+A8V0F0Yil834JvTx3M
        Bin+I3c9e4rmXto3czDS4ppO1hecENw=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-185-975TjRT3OgmhQDUfBRbiCA-1; Fri, 31 Jul 2020 08:04:11 -0400
X-MC-Unique: 975TjRT3OgmhQDUfBRbiCA-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 07F9F59;
        Fri, 31 Jul 2020 12:04:10 +0000 (UTC)
Received: from sandy.ghostprotocols.net (unknown [10.3.128.12])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id B69695DA81;
        Fri, 31 Jul 2020 12:04:08 +0000 (UTC)
Received: by sandy.ghostprotocols.net (Postfix, from userid 1000)
        id 9EBFF202; Fri, 31 Jul 2020 09:04:03 -0300 (BRT)
Date:   Fri, 31 Jul 2020 09:04:03 -0300
From:   Arnaldo Carvalho de Melo <acme@redhat.com>
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     Philippe Duplessis-Guindon <pduplessis@efficios.com>,
        linux-trace-devel@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] tools lib traceevent: Fix memory leak in
 process_dynamic_array_len
Message-ID: <20200731120403.GA4414@redhat.com>
References: <20200730150236.5392-1-pduplessis@efficios.com>
 <20200730172843.653cd9f4@oasis.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200730172843.653cd9f4@oasis.local.home>
X-Url:  http://acmel.wordpress.com
User-Agent: Mutt/1.5.20 (2009-12-10)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Em Thu, Jul 30, 2020 at 05:28:43PM -0400, Steven Rostedt escreveu:
> 
> Arnaldo,
> 
> Can you pull this into your tree under urgent?
> 
>  https://lore.kernel.org/linux-trace-devel/20200730150236.5392-1-pduplessis@efficios.com/
> 
> Reviewed-by: Steven Rostedt (VMware) <rostedt@goodmis.org>

Sure, will get it and try and send today,

- Arnaldo
 
> -- Steve
> 
> 
> On Thu, 30 Jul 2020 11:02:36 -0400
> Philippe Duplessis-Guindon <pduplessis@efficios.com> wrote:
> 
> > I compiled with AddressSanitizer and I had these memory leaks while I
> > was using the tep_parse_format function:
> > 
> >     Direct leak of 28 byte(s) in 4 object(s) allocated from:
> >         #0 0x7fb07db49ffe in __interceptor_realloc (/lib/x86_64-linux-gnu/libasan.so.5+0x10dffe)
> >         #1 0x7fb07a724228 in extend_token /home/pduplessis/repo/linux/tools/lib/traceevent/event-parse.c:985
> >         #2 0x7fb07a724c21 in __read_token /home/pduplessis/repo/linux/tools/lib/traceevent/event-parse.c:1140
> >         #3 0x7fb07a724f78 in read_token /home/pduplessis/repo/linux/tools/lib/traceevent/event-parse.c:1206
> >         #4 0x7fb07a725191 in __read_expect_type /home/pduplessis/repo/linux/tools/lib/traceevent/event-parse.c:1291
> >         #5 0x7fb07a7251df in read_expect_type /home/pduplessis/repo/linux/tools/lib/traceevent/event-parse.c:1299
> >         #6 0x7fb07a72e6c8 in process_dynamic_array_len /home/pduplessis/repo/linux/tools/lib/traceevent/event-parse.c:2849
> >         #7 0x7fb07a7304b8 in process_function /home/pduplessis/repo/linux/tools/lib/traceevent/event-parse.c:3161
> >         #8 0x7fb07a730900 in process_arg_token /home/pduplessis/repo/linux/tools/lib/traceevent/event-parse.c:3207
> >         #9 0x7fb07a727c0b in process_arg /home/pduplessis/repo/linux/tools/lib/traceevent/event-parse.c:1786
> >         #10 0x7fb07a731080 in event_read_print_args /home/pduplessis/repo/linux/tools/lib/traceevent/event-parse.c:3285
> >         #11 0x7fb07a731722 in event_read_print /home/pduplessis/repo/linux/tools/lib/traceevent/event-parse.c:3369
> >         #12 0x7fb07a740054 in __tep_parse_format /home/pduplessis/repo/linux/tools/lib/traceevent/event-parse.c:6335
> >         #13 0x7fb07a74047a in __parse_event /home/pduplessis/repo/linux/tools/lib/traceevent/event-parse.c:6389
> >         #14 0x7fb07a740536 in tep_parse_format /home/pduplessis/repo/linux/tools/lib/traceevent/event-parse.c:6431
> >         #15 0x7fb07a785acf in parse_event ../../../src/fs-src/fs.c:251
> >         #16 0x7fb07a785ccd in parse_systems ../../../src/fs-src/fs.c:284
> >         #17 0x7fb07a786fb3 in read_metadata ../../../src/fs-src/fs.c:593
> >         #18 0x7fb07a78760e in ftrace_fs_source_init ../../../src/fs-src/fs.c:727
> >         #19 0x7fb07d90c19c in add_component_with_init_method_data ../../../../src/lib/graph/graph.c:1048
> >         #20 0x7fb07d90c87b in add_source_component_with_initialize_method_data ../../../../src/lib/graph/graph.c:1127
> >         #21 0x7fb07d90c92a in bt_graph_add_source_component ../../../../src/lib/graph/graph.c:1152
> >         #22 0x55db11aa632e in cmd_run_ctx_create_components_from_config_components ../../../src/cli/babeltrace2.c:2252
> >         #23 0x55db11aa6fda in cmd_run_ctx_create_components ../../../src/cli/babeltrace2.c:2347
> >         #24 0x55db11aa780c in cmd_run ../../../src/cli/babeltrace2.c:2461
> >         #25 0x55db11aa8a7d in main ../../../src/cli/babeltrace2.c:2673
> >         #26 0x7fb07d5460b2 in __libc_start_main (/lib/x86_64-linux-gnu/libc.so.6+0x270b2)
> > 
> > The token variable in the process_dynamic_array_len function is
> > allocated in the read_expect_type function, but is not freed before
> > calling the read_token function.
> > 
> > Free the token variable before calling read_token in order to plug the
> > leak.
> > 
> > Signed-off-by: Philippe Duplessis-Guindon <pduplessis@efficios.com>
> > ---
> >  tools/lib/traceevent/event-parse.c | 1 +
> >  1 file changed, 1 insertion(+)
> > 
> > diff --git a/tools/lib/traceevent/event-parse.c b/tools/lib/traceevent/event-parse.c
> > index 5b36c589a029..ba4f33804af1 100644
> > --- a/tools/lib/traceevent/event-parse.c
> > +++ b/tools/lib/traceevent/event-parse.c
> > @@ -2861,6 +2861,7 @@ process_dynamic_array_len(struct tep_event *event, struct tep_print_arg *arg,
> >  	if (read_expected(TEP_EVENT_DELIM, ")") < 0)
> >  		goto out_err;
> >  
> > +	free_token(token);
> >  	type = read_token(&token);
> >  	*tok = token;
> >  

