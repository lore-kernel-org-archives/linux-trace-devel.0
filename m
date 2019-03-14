Return-Path: <SRS0=grb/=RR=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 546C4C43381
	for <linux-trace-devel@archiver.kernel.org>; Thu, 14 Mar 2019 00:53:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 16958217F5
	for <linux-trace-devel@archiver.kernel.org>; Thu, 14 Mar 2019 00:53:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726568AbfCNAxa (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 13 Mar 2019 20:53:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:44548 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726556AbfCNAxa (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 13 Mar 2019 20:53:30 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A911D2087C;
        Thu, 14 Mar 2019 00:53:29 +0000 (UTC)
Date:   Wed, 13 Mar 2019 20:53:28 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Patrick McLean <chutzpah@gentoo.org>
Cc:     Tzvetomir Stoyanov <tstoyanov@vmware.com>,
        linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH v4 39/46] tools/lib/traceevent: Man pages for
 tep_load_plugins() and tep_unload_plugin()
Message-ID: <20190313205328.66871de8@gandalf.local.home>
In-Reply-To: <20190313144517.656d06c0@patrickm>
References: <20190308133654.21264-1-tstoyanov@vmware.com>
        <20190308133654.21264-40-tstoyanov@vmware.com>
        <20190313162756.336b8b24@gandalf.local.home>
        <20190313144206.41e75cf8@patrickm>
        <20190313144517.656d06c0@patrickm>
X-Mailer: Claws Mail 3.16.0 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Wed, 13 Mar 2019 14:45:17 -0700
Patrick McLean <chutzpah@gentoo.org> wrote:

> > > Patrick, where's the place to put customized plugins that should
> > > overwrite the system ones?
> > >     
> > 
> > That sort of depends, if they are textual and could be considered
> > configs, then .config is where they should go, otherwise
> > ${HOME}/.local/share/traceevent or ${HOME}/.local/lib/traceevent,
> > binaries should go under the lib, arch agnostic stuff should go under
> > share.  
> 
> More information on this spec here:
> https://standards.freedesktop.org/basedir-spec/basedir-spec-latest.html
> 
> The "${HOME}.local/lib" is not listed in the spec, but it is the
> convention that is often used.
> https://standards.freedesktop.org/basedir-spec/basedir-spec-latest.html

Thanks. Note, these can be either .so binaries, or python scripts.

-- Steve
