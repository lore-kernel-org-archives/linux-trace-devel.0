Return-Path: <SRS0=agpe=OH=vger.kernel.org=linux-trace-devel-owner@goodmis.org>
Received: from mail.kernel.org ([198.145.29.99]:52510 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726595AbeK2HSX (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 29 Nov 2018 02:18:23 -0500
Date: Wed, 28 Nov 2018 15:15:31 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Tzvetomir Stoyanov <tstoyanov@vmware.com>
Cc: "linux-trace-devel@vger.kernel.org"
        <linux-trace-devel@vger.kernel.org>
Subject: Re: [PATCH v3 02/15] tools/lib/traceevent: Added support for
 pkg-config
Message-ID: <20181128151531.5067da1a@gandalf.local.home>
In-Reply-To: <20181128151459.4f351a5d@gandalf.local.home>
References: <20181128090711.17792-1-tstoyanov@vmware.com>
        <20181128090711.17792-3-tstoyanov@vmware.com>
        <20181128151459.4f351a5d@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-trace-devel-owner@vger.kernel.org
List-ID: <linux-trace-devel.vger.kernel.org>

On Wed, 28 Nov 2018 15:14:59 -0500
Steven Rostedt <rostedt@goodmis.org> wrote:

> On Wed, 28 Nov 2018 09:07:30 +0000
> Tzvetomir Stoyanov <tstoyanov@vmware.com> wrote:
> 
> > +PKG_CONFIG_FILE = libtraceevent.pc
> > +define do_install_pkgconfig_file
> > +	if [ -n "${pkgconfig_dir}" ]; then 					\
> > +		cp -f ${PKG_CONFIG_FILE}.template ${PKG_CONFIG_FILE}; 		\
> > +		sed -i "s|INSTALL_PREFIX|${1}|g" ${PKG_CONFIG_FILE}; 		\
> > +		sed -i "s|LIB_VERSION|${EVENT_PARSE_VERSION}|g" ${PKG_CONFIG_FILE}; \
> > +		$(call do_install,$(PKG_CONFIG_FILE),$(pkgconfig_dir),644); 	\
> > +	else 									\
> > +		(echo Failed to locate pkg-config directory) 1>&2;		\
> > +	fi	  
> 
> Might want to run checkpatch.pl before sending, as it can catch
> whitespace issues. The above "fi" has a tab after it.
> 
> $ ./scripts/checkpatch.pl mbox.patch
> ERROR: trailing whitespace
> #139: FILE: tools/lib/traceevent/Makefile:285:
> +^Ifi^I$
>

Note, I fixed it before applying.

-- Steve
