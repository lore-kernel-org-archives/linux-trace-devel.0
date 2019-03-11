Return-Path: <SRS0=t4cO=RO=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C63B2C43381
	for <linux-trace-devel@archiver.kernel.org>; Mon, 11 Mar 2019 15:33:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A18892084F
	for <linux-trace-devel@archiver.kernel.org>; Mon, 11 Mar 2019 15:33:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726986AbfCKPdn (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 11 Mar 2019 11:33:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:47884 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726675AbfCKPdn (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 11 Mar 2019 11:33:43 -0400
Received: from oasis.local.home (unknown [12.129.159.195])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6146820657;
        Mon, 11 Mar 2019 15:33:42 +0000 (UTC)
Date:   Mon, 11 Mar 2019 11:33:40 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Slavomir Kaslev <slavomir.kaslev@gmail.com>
Cc:     Yordan Karadzhov <ykaradzhov@vmware.com>,
        linux-trace-devel@vger.kernel.org,
        Patrick McLean <chutzpah@gentoo.org>
Subject: Re: [PATCH 2/3] kernel-shark: Save the configuration information in
 ${HOME}/.kshark
Message-ID: <20190311113340.67260ae7@oasis.local.home>
In-Reply-To: <CAE0o1NsO5nqemTQ5v2HR9bixVKeiO9Dc8=D9-w36o7b15O9P=A@mail.gmail.com>
References: <20190308171512.15372-1-ykaradzhov@vmware.com>
        <20190308171512.15372-3-ykaradzhov@vmware.com>
        <CAE0o1NsO5nqemTQ5v2HR9bixVKeiO9Dc8=D9-w36o7b15O9P=A@mail.gmail.com>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Mon, 11 Mar 2019 14:20:23 +0200
Slavomir Kaslev <slavomir.kaslev@gmail.com> wrote:

> On Fri, Mar 8, 2019 at 7:16 PM Yordan Karadzhov <ykaradzhov@vmware.com> wrote:
> >
> > By default the "Last session" configuration file will be saved in
> > ${HOME}/.kshark  
> 
> ${HOME}/.config/foobar seems to be the standard path these days for
> config files[1]. Wdyt about switching it to ${HOME}/.config/khark?
> 
> [1] https://specifications.freedesktop.org/basedir-spec/basedir-spec-latest.html

Yeah, I was talking with Patrick McLean (who is a package maintainer
for Gentoo) at SCaLE and was saying that we should look at .config. And
that's the reference he pointed me to as well.

Note, we may need to use both .config and .cache, as I'm thinking
that .cache is better for the saving of last session, and .config
should be the default for user defined sessions (Export Session).

-- Steve


> 
> -- Slavi
> 
> >
> > Suggested-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
> > Signed-off-by: Yordan Karadzhov <ykaradzhov@vmware.com>
> > ---
> >  Makefile                    | 2 +-
> >  kernel-shark/CMakeLists.txt | 5 +++--
> >  2 files changed, 4 insertions(+), 3 deletions(-)
> >
> > diff --git a/Makefile b/Makefile
> > index b780718..967c364 100644
> > --- a/Makefile
> > +++ b/Makefile
> > @@ -254,7 +254,7 @@ all_cmd: $(CMD_TARGETS)
> >  CMAKE_COMMAND = /usr/bin/cmake
> >
> >  $(kshark-dir)/build/Makefile: $(kshark-dir)/CMakeLists.txt
> > -       $(Q) cd $(kshark-dir)/build && $(CMAKE_COMMAND) ..
> > +       $(Q) cd $(kshark-dir)/build && $(CMAKE_COMMAND) -DKS_CONF_DIR=$(HOME)/.kshark ..
> >
> >  gui: force $(CMD_TARGETS) $(kshark-dir)/build/Makefile
> >         $(Q)$(MAKE) $(S) -C $(kshark-dir)/build
> > diff --git a/kernel-shark/CMakeLists.txt b/kernel-shark/CMakeLists.txt
> > index 20ced14..3c3beb0 100644
> > --- a/kernel-shark/CMakeLists.txt
> > +++ b/kernel-shark/CMakeLists.txt
> > @@ -14,7 +14,7 @@ set(KS_DIR ${CMAKE_SOURCE_DIR})
> >
> >  # Make a directory to hold configuration files. To change this do:
> >  # cmake .. -DKS_CONF_DIR=/your/preferred/path
> > -set(KS_CONF_DIR "${KS_DIR}/.ksconf" CACHE STRING "Directory for configuration files.")
> > +set(KS_CONF_DIR "$ENV{HOME}/.kshark" CACHE STRING "Directory for configuration files.")
> >  file(MAKE_DIRECTORY ${KS_CONF_DIR})
> >
> >  include(${KS_DIR}/build/FindTraceCmd.cmake)
> > @@ -59,7 +59,8 @@ include_directories(${KS_DIR}/src/
> >  message("")
> >  message(STATUS "C flags      : " ${CMAKE_C_FLAGS})
> >  message(STATUS "CXX flags    : " ${CMAKE_CXX_FLAGS})
> > -message(STATUS "Linker flags : " ${CMAKE_EXE_LINKER_FLAGS})
> > +message(STATUS "Linker flags : " ${CMAKE_EXE_LINKER_FLAGS}\n)
> > +message(STATUS "config. files saved in ${KS_CONF_DIR}")
> >
> >  add_subdirectory(${KS_DIR}/src)
> >  add_subdirectory(${KS_DIR}/examples)
> > --
> > 2.19.1
> >  
> 
> 

