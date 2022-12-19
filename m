Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 390A1C4332F
	for <linux-trace-devel@archiver.kernel.org>; Mon, 19 Dec 2022 13:01:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231700AbiLSNBR (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 19 Dec 2022 08:01:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59714 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231292AbiLSNBQ (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 19 Dec 2022 08:01:16 -0500
Received: from smtp-out2.suse.de (smtp-out2.suse.de [IPv6:2001:67c:2178:6::1d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 033B7F1B;
        Mon, 19 Dec 2022 05:01:14 -0800 (PST)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id D666B609EA;
        Mon, 19 Dec 2022 13:01:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1671454872; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=cu7GZ5jYRiUnWJJskS+YQWDE2y6FSRRDJcyr5q4eRvk=;
        b=Ea8AMWK2c6pj1usU+mQeE0lX/0Cb12gq0gacqNfVG2g/PgrFUvfWyCc5oOWWLXctI+Xd5Z
        isy1pccZq3TuTQWw6n3A6DWwSs5Zfng5K9ClQk42Z1pnh8jdVzuiXJC/WsNleAy6+aXzw4
        CNA/3LXkdlB2s6Zf+JTFZEZAg1wzH+g=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1671454872;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=cu7GZ5jYRiUnWJJskS+YQWDE2y6FSRRDJcyr5q4eRvk=;
        b=GyrfcrRf0LsM/6yeSvEveTbJnO7xSQBjfc3c3RokqdQyQe9Ut5BXCWv5sxQysS//1F/9K8
        KZnETV5uDTIs/8BQ==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id C94A813498;
        Mon, 19 Dec 2022 13:01:12 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id 9YodMZhgoGOsDAAAMHmgww
        (envelope-from <dwagner@suse.de>); Mon, 19 Dec 2022 13:01:12 +0000
Date:   Mon, 19 Dec 2022 14:01:12 +0100
From:   Daniel Wagner <dwagner@suse.de>
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     Arnaldo Carvalho de Melo <acme@kernel.org>,
        linux-trace-devel@vger.kernel.org, linux-perf-users@vger.kernel.org
Subject: Re: [RFC v2] libtraceevent: Add initial support for meson
Message-ID: <20221219130112.cttlfbtgzoot4bq7@carbon.lan>
References: <20220707142723.8721-1-dwagner@suse.de>
 <20221125211847.69b535ea@rorschach.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221125211847.69b535ea@rorschach.local.home>
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Hi Steven

Sorry for the late response, just got back from my vacation.

On Fri, Nov 25, 2022 at 09:18:47PM -0500, Steven Rostedt wrote:
> On Thu,  7 Jul 2022 16:27:23 +0200
> Daniel Wagner <dwagner@suse.de> wrote:
> 
> > Add support for building the project with meson. It's not complete
> > yet, for example building and installing the documentation is missing.
> > 
> > The rest should work as expected. The only thing I was not really
> > clear what the purpose is the libtraceevent-dynamic-list which seems
> > not be used or installed. The meson build will also generate the file
> > but using the host nm and not the cross tool chain if any is used. I
> > didn't want to invest too much time figuring out this detail if it is
> > actually not used.
> 
> It came over from the perf update. See:
> 
>   f1489e5dce74a ("tools lib traceevent: Export dynamic symbols used by traceevent plugins")
> 
> Not sure it's still needed or not.

After looking a bit closer, libtraceevent is not using this information
itself, it's perf which uses this:

  tools/perf/Makefile.perf

  #
  # The static build has no dynsym table, so this does not work for
  # static build. Looks like linker starts to scream about that now
  # (in Fedora 26) so we need to switch it off for static build.
  DYNAMIC_LIST_LDFLAGS               = -Xlinker --dynamic-list=$(LIBTRACEEVENT_DYNAMIC_LIST)
  LIBTRACEEVENT_DYNAMIC_LIST_LDFLAGS = $(if $(findstring -static,$(LDFLAGS)),,$(DYNAMIC_LIST_LDFLAGS))

Right so the kernel has a copy of libtraceevent under
tools/lib/traceevent. But I haven't really understood when this
version of libtraceevent is used. I see in

  tools/perf/Makefile.config

  ifdef LIBTRACEEVENT_DYNAMIC
    $(call feature_check,libtraceevent)
    ifeq ($(feature-libtraceevent), 1)
      EXTLIBS += -ltraceevent
      LIBTRACEEVENT_VERSION := $(shell $(PKG_CONFIG) --modversion libtraceevent)
      LIBTRACEEVENT_VERSION_1 := $(word 1, $(subst ., ,$(LIBTRACEEVENT_VERSION)))
      LIBTRACEEVENT_VERSION_2 := $(word 2, $(subst ., ,$(LIBTRACEEVENT_VERSION)))
      LIBTRACEEVENT_VERSION_3 := $(word 3, $(subst ., ,$(LIBTRACEEVENT_VERSION)))
      LIBTRACEEVENT_VERSION_CPP := $(shell expr $(LIBTRACEEVENT_VERSION_1) \* 255 \* 255 + $(LIBTRACEEVENT_VERSION_2) \* 255 + $(LIBTRACEEVENT_VERSION_3))
      CFLAGS += -DLIBTRACEEVENT_VERSION=$(LIBTRACEEVENT_VERSION_CPP)
    else
      dummy := $(error Error: No libtraceevent devel library found, please install libtraceevent-devel);
    endif
  endif

So this clearly searches for the installed version of the library, but
the

  tools/perf/Makefile.perf

  $(LIBTRACEEVENT_DYNAMIC_LIST): libtraceevent_plugins
          $(Q)$(MAKE) -C $(TRACE_EVENT_DIR)plugins $(LIBTRACEEVENT_FLAGS) O=$(OUTPUT) $(OUTPUT)libtraceevent-dynamic-list

is creating the list from the sources shipped with the kernel? I suspect
the idea here is to create this list and also install it and let the
kernel use libtraceevent list. Unless I am completely confused.

> > Obviously, meson is not make and there are some changes in how to use
> > this build system. The meson documentation is outstanding good and
> > usually has good tips and tricks to solve problems. But sure there is
> > learning curve but hopefully not so step.
> > 
> > Anyway, as pure user the build steps are (in source tree builds are
> > not supported):
> > 
> >   # configure using .build as build directory and install destination
> >   # /tmp/test
> >   meson .build --prefix=/tmp/test
> > 
> >   # trigger the build
> >   ninja -C .build
> > 
> >   # install the library
> >   ninja -C .build install
> 
> When this is all and done, it should still be part of "make".
> 
> That is, make could do the above for the user.

Sure, this shouldn't be a big issue. Many project ship a simple Makefile
for convenience. Though it should be kept simple and should not aim to
support all features IMO.

But given that we currently have a copy of libtraceevent in the kernel,
I think we can't really ditch the Makefile unless we also could drop the
copy in tools/lib/traceevent.

> > +project(
> > +    'libtraceevent', ['c'],
> > +    meson_version: '>= 0.47.0',
> 
> I get a warning:
> 
> WARNING: Project specifies a minimum meson_version '>= 0.47.0' but uses features which were added in newer versions:
>  * 0.50.0: {'include_directories kwarg of type string'}

Meson 0.64.0 add a new warning. For libnvme I opted to update the
minimum version requirement to 0.50.0.

 Version 0.47.0 was released on 2018-07-02
 Version 0.50.0 was released on 2019-03-10

As reference Debian oldstable ships 0.49.0. Debian oldstable is
not likely to update the libtracevent library, so I think it's also okay
for the trace-cmd and it's library to depend on 0.50.0

> > +    license: 'LGPL-2.1',
> > +    version: '1.5.3',
> > +    default_options: [
> > +      'c_std=gnu99',
> > +      'buildtype=release',
> > +      'prefix=/usr',
> 
> default should be in /usr/local

Sure.

Thanks,
Daniel
