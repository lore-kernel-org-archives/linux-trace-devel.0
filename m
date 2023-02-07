Return-Path: <linux-trace-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 19809C636CC
	for <linux-trace-devel@archiver.kernel.org>; Tue,  7 Feb 2023 15:45:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230519AbjBGPpu (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 7 Feb 2023 10:45:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47542 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230347AbjBGPpt (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 7 Feb 2023 10:45:49 -0500
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A72A73A5A9
        for <linux-trace-devel@vger.kernel.org>; Tue,  7 Feb 2023 07:45:48 -0800 (PST)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id 5A05D3FA41;
        Tue,  7 Feb 2023 15:45:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1675784747; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=5ziLzN2+s5WO+EWHek4CJB1jLvPaD+4NokOrNvEVwc0=;
        b=EyggQNpMXZPuTtYqG1kW/E+Z8fqStQO1Eu6uA1UuDVb8WKCHFrZR+oV48hsKT8g+1LWLBF
        Zamb1PA7Ed+j15LYPPx6OEEA2FV94UI7gGU1MEsZp1L96/74mEKC9UGFYoDSImsnj1PPwd
        p5YrbxEGaFGxmjuQGHxwa/7p0Do/lks=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1675784747;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=5ziLzN2+s5WO+EWHek4CJB1jLvPaD+4NokOrNvEVwc0=;
        b=hQKRpD8wk0OBvLBGbgKFk4ly+2WMCpg9rn8H00UGP2bAItncG9saLbc+Sfd863UUbbVz5i
        VGazcye3bT1WW0Bg==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 4D1C313467;
        Tue,  7 Feb 2023 15:45:47 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id FiLGEity4mPeMQAAMHmgww
        (envelope-from <dwagner@suse.de>); Tue, 07 Feb 2023 15:45:47 +0000
Date:   Tue, 7 Feb 2023 16:45:46 +0100
From:   Daniel Wagner <dwagner@suse.de>
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH v6 0/2] Add initial support for meson
Message-ID: <20230207154546.zqfq27swtc66ar2v@carbon.lan>
References: <20230207124634.6515-1-dwagner@suse.de>
 <20230207134825.uexdcqlopkuqehuy@carbon.lan>
 <20230207101001.5ef90b44@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230207101001.5ef90b44@gandalf.local.home>
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Tue, Feb 07, 2023 at 10:10:01AM -0500, Steven Rostedt wrote:
> On Tue, 7 Feb 2023 14:48:25 +0100
> Daniel Wagner <dwagner@suse.de> wrote:
> 
> > On Tue, Feb 07, 2023 at 01:46:32PM +0100, Daniel Wagner wrote:
> > > This version brings a few cleanups on the documentation intallation path
> > > and pkg-config depenedency updates.
> > > 
> > > Changes:
> > > 
> > > v6:
> > >   - lib: isntall trace-cmd.h directly in /usr/include and not subdir
> > >     trace-cmd. kernelshark builds breaks otherwise  
> > 
> > No, this is not the real problem. The Makefile also installs it under
> > /usr/include/trace-cmd.
> 
> But `pkg-config --cflags libtracecmd` should give the right path:
> 
>   -I/usr/include/trace-cmd -I/usr/include/tracefs -I/usr/include/traceevent
> 
> This is the way it's always been. Why are your kernelshark builds breaking?

Not sure what's happening. I've build and installed the library with make
and the kernelshark configuration step still fails. I see the following
output (make and meson):

$ cmake -S . -B foo --debug-find
Running with debug output on for the `find` commands.

 project: Kernel Shark: (version: 2.1.1)

CMake Debug Log at build/FindTraceEvent.cmake:39 (find_package):
  find_package considered the following paths for FindPkgConfig.cmake:

    /home/wagi/work/osc/home:wagi:branches:devel:trace/kernelshark/kernel-shark/build/FindPkgConfig.cmake

  The file was found at

    /usr/share/cmake/Modules/FindPkgConfig.cmake

Call Stack (most recent call first):
  CMakeLists.txt:48 (find_package)


CMake Debug Log at CMakeLists.txt:48 (find_package):
  find_package considered the following paths for FindTraceEvent.cmake:

    /usr/share/cmake/Modules/FindTraceEvent.cmake

  The file was found at

    /home/wagi/work/osc/home:wagi:branches:devel:trace/kernelshark/kernel-shark/build/FindTraceEvent.cmake



CMake Debug Log at build/FindTraceFS.cmake:39 (find_package):
  find_package considered the following paths for FindPkgConfig.cmake:

    /home/wagi/work/osc/home:wagi:branches:devel:trace/kernelshark/kernel-shark/build/FindPkgConfig.cmake

  The file was found at

    /usr/share/cmake/Modules/FindPkgConfig.cmake

Call Stack (most recent call first):
  CMakeLists.txt:49 (find_package)


CMake Debug Log at CMakeLists.txt:49 (find_package):
  find_package considered the following paths for FindTraceFS.cmake:

    /usr/share/cmake/Modules/FindTraceFS.cmake

  The file was found at

    /home/wagi/work/osc/home:wagi:branches:devel:trace/kernelshark/kernel-shark/build/FindTraceFS.cmake



CMake Debug Log at build/FindTraceCmd.cmake:39 (find_package):
  find_package considered the following paths for FindPkgConfig.cmake:

    /home/wagi/work/osc/home:wagi:branches:devel:trace/kernelshark/kernel-shark/build/FindPkgConfig.cmake

  The file was found at

    /usr/share/cmake/Modules/FindPkgConfig.cmake

Call Stack (most recent call first):
  CMakeLists.txt:50 (find_package)


CMake Debug Log at build/FindTraceCmd.cmake:45 (find_path):
  find_path called with the following settings:

    VAR: TraceCmd_INCLUDE_DIR
    NAMES: "trace-cmd.h"
    Documentation: Path to a file.
    Framework
      Only Search Frameworks: 0
      Search Frameworks Last: 0
      Search Frameworks First: 0
    AppBundle
      Only Search AppBundle: 0
      Search AppBundle Last: 0
      Search AppBundle First: 0
    CMAKE_FIND_USE_CMAKE_PATH: 1
    CMAKE_FIND_USE_CMAKE_ENVIRONMENT_PATH: 1
    CMAKE_FIND_USE_SYSTEM_ENVIRONMENT_PATH: 1
    CMAKE_FIND_USE_CMAKE_SYSTEM_PATH: 1
    CMAKE_FIND_USE_INSTALL_PREFIX: 1

  find_path considered the following locations:

    /usr/local/include/trace-cmd/trace-cmd.h
    /usr/include/libtracefs/trace-cmd.h
    /usr/include/traceevent/trace-cmd.h
    /home/wagi/work/osc/home:wagi:branches:devel:trace/kernelshark/kernel-shark/trace-cmd.h
    /home/wagi/bin/trace-cmd.h
    /home/wagi/.local/bin/trace-cmd.h
    /home/wagi/node_modules/.bin/trace-cmd.h
    /home/wagi/work/osc/home:wagi:branches:devel:trace/kernelshark/kernel-shark/usr/local/bin/trace-cmd.h
    /usr/local/bin/trace-cmd.h
    /usr/bin/trace-cmd.h
    /bin/trace-cmd.h
    /usr/local/include/trace-cmd.h
    /usr/local/trace-cmd.h
    /usr/include/trace-cmd.h
    /usr/trace-cmd.h
    /include/trace-cmd.h
    /usr/X11R6/include/trace-cmd.h
    /usr/X11R6/trace-cmd.h
    /usr/pkg/include/trace-cmd.h
    /usr/pkg/trace-cmd.h
    /opt/include/trace-cmd.h
    /opt/trace-cmd.h
    /usr/include/X11/trace-cmd.h

  The item was not found.

Call Stack (most recent call first):
  CMakeLists.txt:50 (find_package)


CMake Error at /usr/share/cmake/Modules/FindPackageHandleStandardArgs.cmake:230 (message):
  Could NOT find TraceCmd (missing: TraceCmd_INCLUDE_DIR)
Call Stack (most recent call first):
  /usr/share/cmake/Modules/FindPackageHandleStandardArgs.cmake:600 (_FPHSA_FAILURE_MESSAGE)
  build/FindTraceCmd.cmake:57 (find_package_handle_standard_args)
  CMakeLists.txt:50 (find_package)


CMake Debug Log at CMakeLists.txt:50 (find_package):
  find_package considered the following paths for FindTraceCmd.cmake:

    /usr/share/cmake/Modules/FindTraceCmd.cmake

  The file was found at

    /home/wagi/work/osc/home:wagi:branches:devel:trace/kernelshark/kernel-shark/build/FindTraceCmd.cmake



-- Configuring incomplete, errors occurred!
See also "/home/wagi/work/osc/home:wagi:branches:devel:trace/kernelshark/kernel-shark/foo/CMakeFiles/CMakeOutput.log".
