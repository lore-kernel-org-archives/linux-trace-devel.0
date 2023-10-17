Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B717405C8
	for <linux-trace-devel@vger.kernel.org>; Tue, 17 Oct 2023 14:57:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=inria.fr header.i=@inria.fr header.b="WcUmfdKh"
Received: from mail3-relais-sop.national.inria.fr (mail3-relais-sop.national.inria.fr [192.134.164.104])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C58602366E
	for <linux-trace-devel@vger.kernel.org>; Tue, 17 Oct 2023 07:57:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=inria.fr; s=dc;
  h=date:from:to:cc:subject:in-reply-to:message-id:
   references:mime-version;
  bh=qBu1gOdER1KOwTLVuE0hTX4dJdDSFtOsJ+sAmQ5TumU=;
  b=WcUmfdKha8VKDUeovypeOlg2BrXtwOlTaHonEqFFACH+FNcM90ugrb3p
   CtIrlL5x7j0qAD2IOZu8pUICfcQcCiiKdfSNDGYQDJX+QJ7sNR0oftdt7
   JfOICEyuxgFJubyySVpf6k3KVjObN9xEqHOwXaSCUDxaammco90cg1Vi1
   g=;
Authentication-Results: mail3-relais-sop.national.inria.fr; dkim=none (message not signed) header.i=none; spf=SoftFail smtp.mailfrom=julia.lawall@inria.fr; dmarc=fail (p=none dis=none) d=inria.fr
X-IronPort-AV: E=Sophos;i="6.03,232,1694728800"; 
   d="scan'208";a="68974771"
Received: from dhcp-138-246-3-50.dynamic.eduroam.mwn.de (HELO hadrien) ([138.246.3.50])
  by mail3-relais-sop.national.inria.fr with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Oct 2023 16:57:50 +0200
Date: Tue, 17 Oct 2023 16:57:49 +0200 (CEST)
From: Julia Lawall <julia.lawall@inria.fr>
To: Steven Rostedt <rostedt@goodmis.org>
cc: Linux Trace Devel <linux-trace-devel@vger.kernel.org>, 
    Yordan Karadzhov <y.karadz@gmail.com>, 
    Masami Hiramatsu <mhiramat@kernel.org>, Ross Zwisler <zwisler@google.com>
Subject: Re: [PATCH] libtracecmd: Use an rbtree for mapping of cache pages
In-Reply-To: <20231017103548.5b2f7af7@gandalf.local.home>
Message-ID: <cbfe1ac7-3cda-b58d-8c22-b5ffa83aed18@inria.fr>
References: <20231016230058.2f0e95b1@gandalf.local.home> <d482ec-641e-f2a5-42d6-fbfdadaa4d2f@inria.fr> <20231017103548.5b2f7af7@gandalf.local.home>
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_MSPIKE_H3,
	RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net



On Tue, 17 Oct 2023, Steven Rostedt wrote:

> On Tue, 17 Oct 2023 09:34:30 +0200 (CEST)
> Julia Lawall <julia.lawall@inria.fr> wrote:
>
> > > And exited out when it finished loading and the result was:
> > >
> > > real    6m14.772s
> > > user    6m0.649s
> > > sys     0m12.718s
> > >
> > > That's over 6 minutes to load the trace.dat file!!!
> > >
> > > I ran perf record on it and it showed 77% of the time was in free_zpage().
> > >
> > > I pulled out my old algorithms book and wrote up a rbtree for internal use
> > > of libtracecmd. Then I switched the cache into a binary rbtree to do the
> > > look ups. As the lookups used both where the memory of the compressed page
> > > is mapped as well as the offset depending on how the search was done, I
> > > found that it only used the memory allocation address in one location.
> > > Luckily, the memory allocation mapping lookup also had access to the
> > > offset of the file the memory represented. That allowed me to make all
> > > lookups use the file offset (Thanks to Masami Hiramatsu for helping me
> > > realize that).
> > >
> > > After converting the cache to an rbtree lookup, I ran kernelshark again on
> > > opening that file and exited out as soon as it finished loading and the
> > > timings was:
> > >
> > > real    1m22.356s
> > > user    1m10.532s
> > > sys     0m10.901s
> > >
> > > Still a bit long, but it dropped from over 6 minutes to under 1 1/2
> > > minutes. Also, free_zpages() was no longer in the perf record output.
> >
> > Does it impact trace-cmd report?
>
> Not as drastically as the above, but running this on the same trace.dat
> file without the patch:
>
>   $ time trace-cmd report trace.dat > /dev/null
>  real    9m20.390s
>  user    9m16.391s
>  sys     0m3.529s
>
> With the patch:
>
>   $ time trace-cmd report trace.dat > /dev/null
>  real    6m22.935s
>  user    6m19.537s
>  sys     0m3.139s
>
> So it does bring it down by a third.

Great!

julia

>
> I need to send a v2 as I found I left some debugging code in, as well as I
> found a small bug in the update of the color of the deleted node if it
> wasn't the node to be deleted.
>
> -- Steve
>
