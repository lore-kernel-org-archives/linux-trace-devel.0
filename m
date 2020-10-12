Return-Path: <SRS0=H9Ya=DT=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 04EF4C433DF
	for <linux-trace-devel@archiver.kernel.org>; Mon, 12 Oct 2020 18:52:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A274C2087D
	for <linux-trace-devel@archiver.kernel.org>; Mon, 12 Oct 2020 18:52:28 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="UYuHXCWM"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727115AbgJLSw2 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 12 Oct 2020 14:52:28 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:58994 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726863AbgJLSw2 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 12 Oct 2020 14:52:28 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1602528747;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=QckrLXy9afNM8oJ/m1vNI39ds6Cr0LMW/RHNAvEvOZc=;
        b=UYuHXCWMjJEkLSfj2Wp4HC4qYlx4ChItwPRY1Y4Pr1UqvrcFlQf2vVJwgS+gtEn7bD3DNt
        YD1Tu90LzoNukAMsmw8oyjLwm1ptRlMurUosvuEdU0vb4ZPfYiEuK0wTvoU7GLVdsFu+pb
        FULzzmh1usrHX918wFq1f+CCj4ZEEdw=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-40-ZQYofs9oM0-aQWVb89uUSQ-1; Mon, 12 Oct 2020 14:52:25 -0400
X-MC-Unique: ZQYofs9oM0-aQWVb89uUSQ-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 3610C879517;
        Mon, 12 Oct 2020 18:52:23 +0000 (UTC)
Received: from krava (unknown [10.40.192.57])
        by smtp.corp.redhat.com (Postfix) with SMTP id EA3BD60BF3;
        Mon, 12 Oct 2020 18:52:18 +0000 (UTC)
Date:   Mon, 12 Oct 2020 20:52:17 +0200
From:   Jiri Olsa <jolsa@redhat.com>
To:     Tony Jones <tonyj@suse.de>
Cc:     Steven Rostedt <rostedt@goodmis.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Linux Trace Devel <linux-trace-devel@vger.kernel.org>,
        Zamir SUN <sztsian@gmail.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        zsun@redhat.com, Vitaly Chikunov <vt@altlinux.org>,
        Tzvetomir Stoyanov <tstoyanov@vmware.com>,
        Yordan Karadzhov <ykaradzhov@vmware.com>,
        Ben Hutchings <ben@decadent.org.uk>,
        Sudip Mukherjee <sudipm.mukherjee@gmail.com>,
        John Kacur <jkacur@redhat.com>,
        Clark Williams <williams@redhat.com>, powertop@lists.01.org,
        Al Stone <ahs3@debian.org>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Subject: Re: [ANNOUNCE] libtraceevent.git
Message-ID: <20201012185217.GB1158208@krava>
References: <20201007130750.49349844@gandalf.local.home>
 <20201012101208.GF1099489@krava>
 <20201012111950.55a73588@gandalf.local.home>
 <20201012184120.GN13697@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201012184120.GN13697@suse.de>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Mon, Oct 12, 2020 at 11:41:20AM -0700, Tony Jones wrote:
> On Mon, Oct 12, 2020 at 11:19:50AM -0400, Steven Rostedt wrote:
> 
> > Once it's shown that it works for all the package maintainers, I will tag
> > it which should create the tarballs automatically on the above link.
> 
> Hi.
> 
> It builds fine for me after manually creating the tarball from git.  
> Once there is an official versioned tarball I'll push it into
> openSUSE.
> 
> I presume some perf Makefile changes will be forthcoming to use it,
> rather than continuing to force build it out of TRACE_EVENT_DIR

right, we need to detect it in features like any other library
and use it if it's found

jirka

