Return-Path: <SRS0=z2Pp=2X=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AFBBFC3276C
	for <linux-trace-devel@archiver.kernel.org>; Thu,  2 Jan 2020 23:50:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7DE9622314
	for <linux-trace-devel@archiver.kernel.org>; Thu,  2 Jan 2020 23:50:04 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Hp+747Sd"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726927AbgABXuE (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 2 Jan 2020 18:50:04 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:50276 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725890AbgABXuD (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 2 Jan 2020 18:50:03 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1578009002;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Xcf0YP80Mto0kO83rbF2DzFh7h3JXBfJISRV5C5tT8E=;
        b=Hp+747SdWGnwd808hqScoSDWanDwrd6CZbgLJiSblGoDH3gCjuMaWMOng9M7+GRm2k1Vv2
        H0CcQF6F5wz/wTEyhphH/5UYsfrgS+cYL20DzRGz04xxqjLopWK+cfZVz+Je3cR55fiRJF
        ZGBogncoekp1qR0Oh2wzHOCMN3tAOC4=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-121-_8idDAM8OMyvONYDDL_zvA-1; Thu, 02 Jan 2020 18:49:57 -0500
X-MC-Unique: _8idDAM8OMyvONYDDL_zvA-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id D5FFD180124F;
        Thu,  2 Jan 2020 23:49:55 +0000 (UTC)
Received: from krava (ovpn-204-83.brq.redhat.com [10.40.204.83])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id C734C7A4F1;
        Thu,  2 Jan 2020 23:49:53 +0000 (UTC)
Date:   Fri, 3 Jan 2020 00:49:50 +0100
From:   Jiri Olsa <jolsa@redhat.com>
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     Sudip Mukherjee <sudipm.mukherjee@gmail.com>,
        Ingo Molnar <mingo@kernel.org>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Namhyung Kim <namhyung@kernel.org>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Linux Trace Devel <linux-trace-devel@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [RFC] tools lib traceevent: How to do library versioning being
 in the Linux kernel source?
Message-ID: <20200102234950.GA14768@krava>
References: <20200102122004.216c85da@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200102122004.216c85da@gandalf.local.home>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Thu, Jan 02, 2020 at 12:20:04PM -0500, Steven Rostedt wrote:
> First, I hope everyone had a Happy New Year!

heya, Happy New Year! ;-)

> 
> Next, Sudip has been working to get the libtraceevent library into
> Debian. As this has been happening, I've been working at how to get all
> the projects that use this, to use the library installed on the system
> if it does exist. I'm hoping that once it's in Debian, the other
> distros will follow suit.
> 
> Currently, the home of libtraceevent lives in the Linux kernel source
> tree under tools/lib/traceevent. This was because perf uses it to parse
> the events, and it seemed logical (at the time) to use this location as
> the main source tree for the distributions.
> 
> The problem I'm now having is that I'm looking at fixing and updating
> some of the code in this library, and since library versioning is
> critical for applications that depend on it, we need to have a way to
> update the versions, and this does not correspond with the Linux
> versions.
> 
> For example, we currently have:
> 
>  libtraceevent.so.1.1.0
> 
> If I make some bug fixes, I probably want to change it to:
> 
>  libtraceevent.so.1.1.1 or libtraceevent.so.1.2.0
> 
> But if I change the API, which I plan on doing soon, I would probably
> need to update the major version.
> 
>  libtraceevent.so.2.0.0
> 
> The thing is, we shouldn't be making these changes for every update
> that we send to the main kernel. I would like to have a minimum of tags
> to state what the version should be, and perhaps even branches for
> working on a development version.
> 
> This is a problem with living in the Linux source tree as tags and
> branches in Linus's tree are for only the Linux kernel source itself.
> This may work fine for perf, as it's not a library and there's not
> tools depending on the version of it. But it is a problem when it comes
> to shared libraries.
> 
> Should we move libtraceevent into a stand alone git repo (on
> kernel.org), that can have tags and branches specifically for it? We
> can keep a copy in the Linux source tree for perf to use till it

so libbpf 'moved' for this reason to github repo,
but keeping the kernel as the true/first source,
and updating github repo when release is ready

libbpf github repo is then source for fedora (and others)
package


> becomes something that is reliably in all distributions. It's not like
> perf doesn't depend on other libraries today anyway.

yep, we already have a way to link libbpf dynamicaly from package,
will work the same for libtraceevent

jirka

