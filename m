Return-Path: <SRS0=jjA2=BI=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EE0D2C433DF
	for <linux-trace-devel@archiver.kernel.org>; Wed, 29 Jul 2020 20:59:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CC0B32075D
	for <linux-trace-devel@archiver.kernel.org>; Wed, 29 Jul 2020 20:59:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1596056374;
	bh=Mn8brCBFVqckHWkhXrs+349x6KJ1I5UsR8vIUKN/gyQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=NvluoQdHIls0GmIrNZ8QpS/JOEg5MPjm94QUSlRXCR0O1ug2OQiHAkd6KGSiJAiDV
	 4afEnqe0yfoPVKrroBqJy1xNk82hkIg+E85XZ+e3YySpTNaQJAQxrpwvT4zOKObKfM
	 KTd7PwDpmc2xD04jbVVjvKeP6mZ9eQWLuHavHRYg=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726821AbgG2U7e (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 29 Jul 2020 16:59:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:35186 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726496AbgG2U7a (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 29 Jul 2020 16:59:30 -0400
Received: from quaco.ghostprotocols.net (unknown [179.97.37.151])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 084882074B;
        Wed, 29 Jul 2020 20:59:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1596056370;
        bh=Mn8brCBFVqckHWkhXrs+349x6KJ1I5UsR8vIUKN/gyQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=XjJyop7tWsA9xcX7t9O8pLf8YPpibcU8JeO2YjP831wQhAJSd4EK22pZIx3mUY5GN
         b9rYhrTuPIKerbjBgbWj91aOEmaX39QkKGTZV81zfxXeWhgRH0zL+DBp5Fw7CHoiAO
         evNIJor3U2CPZMxphlPdJ6irrboFAlJOMXtt5gQM=
Received: by quaco.ghostprotocols.net (Postfix, from userid 1000)
        id DE30740E6B; Wed, 29 Jul 2020 17:59:27 -0300 (-03)
Date:   Wed, 29 Jul 2020 17:59:27 -0300
From:   Arnaldo Carvalho de Melo <acme@kernel.org>
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     Ben Hutchings <ben@decadent.org.uk>,
        linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH] libtraceevent: Fix build with binutils 2.35
Message-ID: <20200729205927.GH433799@kernel.org>
References: <20200725010623.GA194964@decadent.org.uk>
 <20200728121908.GG40195@kernel.org>
 <20200728090806.10e43f96@oasis.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200728090806.10e43f96@oasis.local.home>
X-Url:  http://acmel.wordpress.com
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Em Tue, Jul 28, 2020 at 09:08:06AM -0400, Steven Rostedt escreveu:
> On Tue, 28 Jul 2020 09:19:08 -0300
> Arnaldo Carvalho de Melo <acme@kernel.org> wrote:
> 
> > Em Sat, Jul 25, 2020 at 02:06:23AM +0100, Ben Hutchings escreveu:
> > > In binutils 2.35, 'nm -D' changed to show symbol versions along with
> > > symbol names, with the usual @@ separator.  When generating
> > > libtraceevent-dynamic-list we need just the names, so strip off the
> > > version suffix if present.  
> > 
> > Steven, have you seen this one?
> 
> Yeah, I saw it. Just haven't gotten to it yet ;-)

So, I've stumbled on this on debian:experimental:

  LINK     /tmp/build/perf/perf
/usr/bin/ld:/tmp/build/perf/libtraceevent-dynamic-list:2: ignoring invalid character `@' in script
/usr/bin/ld:/tmp/build/perf/libtraceevent-dynamic-list:2: ignoring invalid character `@' in script
/usr/bin/ld:/tmp/build/perf/libtraceevent-dynamic-list:2: syntax error in dynamic list
collect2: error: ld returned 1 exit status
make[2]: *** [Makefile.perf:637: /tmp/build/perf/perf] Error 1

I'll tentatively add this patch to see if it then passes all the tests
everywhere...

- Arnaldo

 
> -- Steve
> 
> > 
> > - Arnaldo
> >  
> > > Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
> > > Cc: stable@vger.kernel.org
> > > ---
> > >  tools/lib/traceevent/plugins/Makefile | 2 +-
> > >  1 file changed, 1 insertion(+), 1 deletion(-)
> > > 
> > > diff --git a/tools/lib/traceevent/plugins/Makefile b/tools/lib/traceevent/plugins/Makefile
> > > index 349bb81482ab..680d883efe05 100644
> > > --- a/tools/lib/traceevent/plugins/Makefile
> > > +++ b/tools/lib/traceevent/plugins/Makefile
> > > @@ -197,7 +197,7 @@ define do_generate_dynamic_list_file
> > >  	xargs echo "U w W" | tr 'w ' 'W\n' | sort -u | xargs echo`;\
> > >  	if [ "$$symbol_type" = "U W" ];then				\
> > >  		(echo '{';                                              \
> > > -		$(NM) -u -D $1 | awk 'NF>1 {print "\t"$$2";"}' | sort -u;\
> > > +		$(NM) -u -D $1 | awk 'NF>1 {sub("@.*", "", $$2); print "\t"$$2";"}' | sort -u;\
> > >  		echo '};';                                              \
> > >  		) > $2;                                                 \
> > >  	else                                                            \  
> > 
> > 
> > 
> 

-- 

- Arnaldo
