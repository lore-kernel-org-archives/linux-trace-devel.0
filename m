Return-Path: <SRS0=DbCI=BH=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.5 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_2 autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 65749C433E1
	for <linux-trace-devel@archiver.kernel.org>; Tue, 28 Jul 2020 13:08:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3E81820714
	for <linux-trace-devel@archiver.kernel.org>; Tue, 28 Jul 2020 13:08:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729421AbgG1NIJ (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 28 Jul 2020 09:08:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:37784 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729044AbgG1NII (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 28 Jul 2020 09:08:08 -0400
Received: from oasis.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 50FE0206D4;
        Tue, 28 Jul 2020 13:08:08 +0000 (UTC)
Date:   Tue, 28 Jul 2020 09:08:06 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Arnaldo Carvalho de Melo <acme@kernel.org>
Cc:     Ben Hutchings <ben@decadent.org.uk>,
        linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH] libtraceevent: Fix build with binutils 2.35
Message-ID: <20200728090806.10e43f96@oasis.local.home>
In-Reply-To: <20200728121908.GG40195@kernel.org>
References: <20200725010623.GA194964@decadent.org.uk>
        <20200728121908.GG40195@kernel.org>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Tue, 28 Jul 2020 09:19:08 -0300
Arnaldo Carvalho de Melo <acme@kernel.org> wrote:

> Em Sat, Jul 25, 2020 at 02:06:23AM +0100, Ben Hutchings escreveu:
> > In binutils 2.35, 'nm -D' changed to show symbol versions along with
> > symbol names, with the usual @@ separator.  When generating
> > libtraceevent-dynamic-list we need just the names, so strip off the
> > version suffix if present.  
> 
> Steven, have you seen this one?

Yeah, I saw it. Just haven't gotten to it yet ;-)

-- Steve

> 
> - Arnaldo
>  
> > Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
> > Cc: stable@vger.kernel.org
> > ---
> >  tools/lib/traceevent/plugins/Makefile | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> > 
> > diff --git a/tools/lib/traceevent/plugins/Makefile b/tools/lib/traceevent/plugins/Makefile
> > index 349bb81482ab..680d883efe05 100644
> > --- a/tools/lib/traceevent/plugins/Makefile
> > +++ b/tools/lib/traceevent/plugins/Makefile
> > @@ -197,7 +197,7 @@ define do_generate_dynamic_list_file
> >  	xargs echo "U w W" | tr 'w ' 'W\n' | sort -u | xargs echo`;\
> >  	if [ "$$symbol_type" = "U W" ];then				\
> >  		(echo '{';                                              \
> > -		$(NM) -u -D $1 | awk 'NF>1 {print "\t"$$2";"}' | sort -u;\
> > +		$(NM) -u -D $1 | awk 'NF>1 {sub("@.*", "", $$2); print "\t"$$2";"}' | sort -u;\
> >  		echo '};';                                              \
> >  		) > $2;                                                 \
> >  	else                                                            \  
> 
> 
> 

