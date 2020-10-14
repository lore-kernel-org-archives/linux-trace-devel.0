Return-Path: <SRS0=7UrD=DV=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_2 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7D22BC433E7
	for <linux-trace-devel@archiver.kernel.org>; Wed, 14 Oct 2020 17:25:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2AE3E221EB
	for <linux-trace-devel@archiver.kernel.org>; Wed, 14 Oct 2020 17:25:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729057AbgJNRZa (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 14 Oct 2020 13:25:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:52730 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726057AbgJNRZa (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 14 Oct 2020 13:25:30 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D0C302173E;
        Wed, 14 Oct 2020 17:25:27 +0000 (UTC)
Date:   Wed, 14 Oct 2020 13:25:26 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Zamir SUN <sztsian@gmail.com>
Cc:     Tony Jones <tonyj@suse.de>, Jiri Olsa <jolsa@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Linux Trace Devel <linux-trace-devel@vger.kernel.org>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        "Ziqian SUN (Zamir)" <zsun@redhat.com>,
        Vitaly Chikunov <vt@altlinux.org>,
        Tzvetomir Stoyanov <tstoyanov@vmware.com>,
        Yordan Karadzhov <ykaradzhov@vmware.com>,
        Ben Hutchings <ben@decadent.org.uk>,
        Sudip Mukherjee <sudipm.mukherjee@gmail.com>,
        John Kacur <jkacur@redhat.com>,
        Clark Williams <williams@redhat.com>,
        Al Stone <ahs3@debian.org>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Subject: Re: [ANNOUNCE] libtraceevent.git
Message-ID: <20201014132526.70b8684c@gandalf.local.home>
In-Reply-To: <7997c7e5-481e-a1d6-d785-f1ed18ebf3d4@gmail.com>
References: <20201007130750.49349844@gandalf.local.home>
        <20201012101208.GF1099489@krava>
        <20201012111950.55a73588@gandalf.local.home>
        <20201012184120.GN13697@suse.de>
        <20201012151732.6e439886@gandalf.local.home>
        <CAHnb8o61XwvgkMnryaOv-=qCDf-o5OpezQAAk-44R+KgCc8Vcw@mail.gmail.com>
        <20201013090228.78256290@gandalf.local.home>
        <7997c7e5-481e-a1d6-d785-f1ed18ebf3d4@gmail.com>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Wed, 14 Oct 2020 20:56:53 +0800
Zamir SUN <sztsian@gmail.com> wrote:

> > 
> > So should I just add that one patch and tag it?
> >   
> 
> That would be great, at least for Fedora packaging.

I'm going with version 1.1.0 and not following the kernel versioning, as
that would just add to the confusion.

Here's the tarball:

  https://git.kernel.org/pub/scm/libs/libtrace/libtraceevent.git/snapshot/libtraceevent-1.1.0.tar.gz

-- Steve

