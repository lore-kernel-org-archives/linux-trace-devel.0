Return-Path: <SRS0=fydL=DO=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_2 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 54E38C41604
	for <linux-trace-devel@archiver.kernel.org>; Wed,  7 Oct 2020 17:07:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F1FCA2173E
	for <linux-trace-devel@archiver.kernel.org>; Wed,  7 Oct 2020 17:07:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727242AbgJGRHy (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 7 Oct 2020 13:07:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:53890 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726168AbgJGRHy (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 7 Oct 2020 13:07:54 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3F0CE21582;
        Wed,  7 Oct 2020 17:07:52 +0000 (UTC)
Date:   Wed, 7 Oct 2020 13:07:50 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     LKML <linux-kernel@vger.kernel.org>,
        Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Cc:     Zamir SUN <sztsian@gmail.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Jiri Olsa <jolsa@redhat.com>, zsun@redhat.com,
        Vitaly Chikunov <vt@altlinux.org>,
        Tzvetomir Stoyanov <tstoyanov@vmware.com>,
        Yordan Karadzhov <ykaradzhov@vmware.com>,
        Ben Hutchings <ben@decadent.org.uk>,
        Sudip Mukherjee <sudipm.mukherjee@gmail.com>,
        Tony Jones <tonyj@suse.de>, John Kacur <jkacur@redhat.com>,
        Clark Williams <williams@redhat.com>, powertop@lists.01.org,
        Al Stone <ahs3@debian.org>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Subject: [ANNOUNCE] libtraceevent.git
Message-ID: <20201007130750.49349844@gandalf.local.home>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

I split out tools/lib/traceevent from the kernel tree using "git subtree",
which recreates all the commits of a directory and makes that directory a
stand alone. I then updated the Makefiles, and copied over some of the
header files used to build the library. I pushed this up to:

  https://git.kernel.org/pub/scm/libs/libtrace/libtraceevent.git/

My hope is that this will now be the source of all updates to the
libtraceevent library that can be used as a stand alone package that both
perf and tracecmd can use. I would also like powertop and rasdaemon to use
this as well.

-- Steve
