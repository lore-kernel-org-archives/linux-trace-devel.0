Return-Path: <SRS0=BXa2=RQ=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D909BC43381
	for <linux-trace-devel@archiver.kernel.org>; Wed, 13 Mar 2019 21:45:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A7EE920854
	for <linux-trace-devel@archiver.kernel.org>; Wed, 13 Mar 2019 21:45:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727308AbfCMVpU (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 13 Mar 2019 17:45:20 -0400
Received: from smtp.gentoo.org ([140.211.166.183]:49390 "EHLO smtp.gentoo.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727217AbfCMVpU (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 13 Mar 2019 17:45:20 -0400
Received: from patrickm (unknown [100.42.98.196])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: chutzpah)
        by smtp.gentoo.org (Postfix) with ESMTPSA id 70DC6335D05;
        Wed, 13 Mar 2019 21:45:19 +0000 (UTC)
Date:   Wed, 13 Mar 2019 14:45:17 -0700
From:   Patrick McLean <chutzpah@gentoo.org>
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     Tzvetomir Stoyanov <tstoyanov@vmware.com>,
        linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH v4 39/46] tools/lib/traceevent: Man pages for
 tep_load_plugins() and tep_unload_plugin()
Message-ID: <20190313144517.656d06c0@patrickm>
In-Reply-To: <20190313144206.41e75cf8@patrickm>
References: <20190308133654.21264-1-tstoyanov@vmware.com>
        <20190308133654.21264-40-tstoyanov@vmware.com>
        <20190313162756.336b8b24@gandalf.local.home>
        <20190313144206.41e75cf8@patrickm>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Wed, 13 Mar 2019 14:42:06 -0700
Patrick McLean <chutzpah@gentoo.org> wrote:

> On Wed, 13 Mar 2019 16:27:56 -0400
> Steven Rostedt <rostedt@goodmis.org> wrote:
> 
> > On Fri,  8 Mar 2019 15:36:47 +0200
> > Tzvetomir Stoyanov <tstoyanov@vmware.com> wrote:
> >   
> > > Create man pages for tep_load_plugins() and tep_unload_plugin()
> > > as part of the libtraceevent APIs.
> > > 
> > > Signed-off-by: Tzvetomir Stoyanov <tstoyanov@vmware.com>
> > > ---
> > >  .../Documentation/libtraceevent-plugins.txt   | 98
> > > +++++++++++++++++++ 1 file changed, 98 insertions(+)
> > >  create mode 100644
> > > tools/lib/traceevent/Documentation/libtraceevent-plugins.txt
> > > 
> > > diff --git
> > > a/tools/lib/traceevent/Documentation/libtraceevent-plugins.txt
> > > b/tools/lib/traceevent/Documentation/libtraceevent-plugins.txt new
> > > file mode 100644 index 000000000000..0f40d14944c0 --- /dev/null
> > > +++ b/tools/lib/traceevent/Documentation/libtraceevent-plugins.txt
> > > @@ -0,0 +1,98 @@
> > > +libtraceevent(3)
> > > +================
> > > +
> > > +NAME
> > > +----
> > > +tep_load_plugins,tep_unload_plugins - Load  / unload traceevent
> > > plugins +
> > > +SYNOPSIS
> > > +--------
> > > +[verse]
> > > +--
> > > +*#include <event-parse.h>*
> > > +
> > > +struct tep_plugin_list pass:[*]*tep_load_plugins*(struct
> > > tep_handle pass:[*]_tep_); +void *tep_unload_plugins*(struct
> > > tep_plugin_list pass:[*]_plugin_list_, struct tep_handle
> > > pass:[*]_tep_); +-- +
> > > +DESCRIPTION
> > > +-----------
> > > +The _tep_load_plugins()_ function loads all plugins, located in
> > > the plugin +directories. The _tep_ argument is trace event parser
> > > context. +The plugin directories are :
> > > +[verse]
> > > +--
> > > +	- System's plugin directory, defined at the library
> > > compile time. It
> > > +	  depends on the library installation prefix and usually
> > > is
> > > +	  _(install_preffix)/lib/traceevent/plugins_
> > > +	- Directory, defined by the environment variable
> > > _TRACEEVENT_PLUGIN_DIR_
> > > +	- User's plugin directory, located at
> > > _~/.traceevent/plugins_    
> > 
> > We are going to need to modify this to be more compliant with
> > today's desktops.
> > 
> > Patrick, where's the place to put customized plugins that should
> > overwrite the system ones?
> >   
> 
> That sort of depends, if they are textual and could be considered
> configs, then .config is where they should go, otherwise
> ${HOME}/.local/share/traceevent or ${HOME}/.local/lib/traceevent,
> binaries should go under the lib, arch agnostic stuff should go under
> share.

More information on this spec here:
https://standards.freedesktop.org/basedir-spec/basedir-spec-latest.html

The "${HOME}.local/lib" is not listed in the spec, but it is the
convention that is often used.
https://standards.freedesktop.org/basedir-spec/basedir-spec-latest.html
