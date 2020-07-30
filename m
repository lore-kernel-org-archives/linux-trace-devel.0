Return-Path: <SRS0=u2KR=BJ=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 12BB3C433DF
	for <linux-trace-devel@archiver.kernel.org>; Thu, 30 Jul 2020 10:03:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E10442083B
	for <linux-trace-devel@archiver.kernel.org>; Thu, 30 Jul 2020 10:02:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1596103379;
	bh=ouovVngIf6hDa3uFlgNThQq8UIE6cztUpcfjbYWOwVs=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=SLMJKEHw1FDnAwS5cfejZkPTErO3JdASSW3ms5Uqr1m4CJ6Rnd8TWhNpAORoWHajG
	 ESUaUU/n8Mgtu3oCx6qd9Wq9fAZXNJcncXeUM2UNSP0j30cWb7VjBEVuDL5AvLN9Z2
	 i1UgVFCbIXKoNbK4MQwQzI612DHz6lB4oDjdoeQI=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726868AbgG3KC7 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 30 Jul 2020 06:02:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:56438 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726847AbgG3KC7 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 30 Jul 2020 06:02:59 -0400
Received: from quaco.ghostprotocols.net (unknown [179.97.37.151])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 79DF32082E;
        Thu, 30 Jul 2020 10:02:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1596103378;
        bh=ouovVngIf6hDa3uFlgNThQq8UIE6cztUpcfjbYWOwVs=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Sk+oNz+4irgtf3PrewYvTnknti2OGjheC4boupamTF9AQp8qVnQmVzLQ83/Eyez0J
         4GWbDo5SfpHo3hZNBXCsdYu/9AjrrnObzNEy/S4HYaT5HWiYwu2X8bLjqDAeIu/l5/
         +j+0YV3fcNAUhOJdmVR/nsYq61bzrlHv7njx+4lA=
Received: by quaco.ghostprotocols.net (Postfix, from userid 1000)
        id 9EDC040E57; Thu, 30 Jul 2020 07:02:56 -0300 (-03)
Date:   Thu, 30 Jul 2020 07:02:56 -0300
From:   Arnaldo Carvalho de Melo <acme@kernel.org>
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     Ben Hutchings <ben@decadent.org.uk>,
        linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH] libtraceevent: Fix build with binutils 2.35
Message-ID: <20200730100256.GC424218@kernel.org>
References: <20200725010623.GA194964@decadent.org.uk>
 <20200728121908.GG40195@kernel.org>
 <20200728090806.10e43f96@oasis.local.home>
 <20200729205927.GH433799@kernel.org>
 <20200729201143.455ffcc2@oasis.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200729201143.455ffcc2@oasis.local.home>
X-Url:  http://acmel.wordpress.com
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Em Wed, Jul 29, 2020 at 08:11:43PM -0400, Steven Rostedt escreveu:
> On Wed, 29 Jul 2020 17:59:27 -0300
> Arnaldo Carvalho de Melo <acme@kernel.org> wrote:
> 
> > Em Tue, Jul 28, 2020 at 09:08:06AM -0400, Steven Rostedt escreveu:
> > > On Tue, 28 Jul 2020 09:19:08 -0300
> > > Arnaldo Carvalho de Melo <acme@kernel.org> wrote:
> > >   
> > > > Em Sat, Jul 25, 2020 at 02:06:23AM +0100, Ben Hutchings escreveu:  
> > > > > In binutils 2.35, 'nm -D' changed to show symbol versions along with
> > > > > symbol names, with the usual @@ separator.  When generating
> > > > > libtraceevent-dynamic-list we need just the names, so strip off the
> > > > > version suffix if present.    
> > > > 
> > > > Steven, have you seen this one?  
> > > 
> > > Yeah, I saw it. Just haven't gotten to it yet ;-)  
> > 
> > So, I've stumbled on this on debian:experimental:
> > 
> >   LINK     /tmp/build/perf/perf
> > /usr/bin/ld:/tmp/build/perf/libtraceevent-dynamic-list:2: ignoring invalid character `@' in script
> > /usr/bin/ld:/tmp/build/perf/libtraceevent-dynamic-list:2: ignoring invalid character `@' in script
> > /usr/bin/ld:/tmp/build/perf/libtraceevent-dynamic-list:2: syntax error in dynamic list
> > collect2: error: ld returned 1 exit status
> > make[2]: *** [Makefile.perf:637: /tmp/build/perf/perf] Error 1
> > 
> > I'll tentatively add this patch to see if it then passes all the tests
> > everywhere...
> > 
> > -
> 
> I'd say go ahead and apply it.
> 
> Reviewed-by: Steven Rostedt (VMware) <rostedt@goodmis.org>

Done, thanks, testing finished in all containers without build problems.

- Arnaldo
