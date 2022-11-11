Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C564CC4332F
	for <linux-trace-devel@archiver.kernel.org>; Fri, 11 Nov 2022 15:53:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234115AbiKKPxT (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 11 Nov 2022 10:53:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36284 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234081AbiKKPxQ (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 11 Nov 2022 10:53:16 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E91CEFDB;
        Fri, 11 Nov 2022 07:53:15 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8A5C762020;
        Fri, 11 Nov 2022 15:53:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 76FBAC433D7;
        Fri, 11 Nov 2022 15:53:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1668181994;
        bh=827LrRq+aAVe6d/B8oWF9ujEZQmWxfy7tuvicaZNH6s=;
        h=From:To:Cc:Subject:Date:From;
        b=Wrq/F6/2OcyhhipMfxPcuZx+8WO0euR/B8TXvoqhNYdi2XfkqOQ+BrSBnTRp6ZE7B
         H7vC4maxMxrLisUZ4KY+LKeInE2UxhjskatPMp+wJ/Fys8RLh7RGf/n2tvIjO2RTHB
         ty37kNv8asVzAxP+QBrQmX8FOhIfRLM8qf4o+KlJ7oyUDmBxILUjPDtQlWqZpwX/AJ
         /dkKaNt/rHzgI1bB6QUKmv+RrSksXnnrwgQZEcSsIikpcRbOg1N5J4sIIHQbRtXNHd
         7jA+4OPNl/rlgb3fW54xBHvjsXVti7XFYGPygWXp892VFDfA2SzcMg7Zbryr5UlkLa
         /g+MtYhszn7zg==
From:   Daniel Bristot de Oliveira <bristot@kernel.org>
To:     Steven Rostedt <rostedt@goodmis.org>,
        linux-trace-devel@vger.kernel.org
Cc:     Daniel Bristot de Oliveira <bristot@kernel.org>,
        Jonathan Corbet <corbet@lwn.net>, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH V2 0/3] verification/rv: Add rv tool
Date:   Fri, 11 Nov 2022 16:53:04 +0100
Message-Id: <cover.1668180100.git.bristot@kernel.org>
X-Mailer: git-send-email 2.37.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

This is the (user-space) runtime verification tool named rv.

This tool aims to be the interface for in-kernel rv monitors, as
well as the home for user-space controlled monitors.

The tool receives a command as the first argument, the current
commands are:

  list	- list all available monitors
  mon	- run a given monitor

Each monitor is an independent piece of software inside the
tool and can have their own arguments.

Changes from v1:
  - typos and format
  - fixed __ikm_read_enable() value check in ikm_read_enable()
  - adjust patch 2 log
  - improved function comments (mainly those /**).

Daniel Bristot de Oliveira (3):
  rv: Add rv tool
  tools/rv: Add in-kernel monitor interface
  Documentation/rv: Add verification/rv man pages

 Documentation/tools/index.rst              |   1 +
 Documentation/tools/rv/Makefile            |  52 ++
 Documentation/tools/rv/common_appendix.rst |  16 +
 Documentation/tools/rv/common_ikm.rst      |  21 +
 Documentation/tools/rv/index.rst           |  24 +
 Documentation/tools/rv/rv-list.rst         |  43 ++
 Documentation/tools/rv/rv-mon-wip.rst      |  44 ++
 Documentation/tools/rv/rv-mon-wwnr.rst     |  43 ++
 Documentation/tools/rv/rv-mon.rst          |  55 ++
 Documentation/tools/rv/rv.rst              |  63 ++
 tools/verification/rv/Makefile             | 141 +++++
 tools/verification/rv/README.txt           |  38 ++
 tools/verification/rv/include/in_kernel.h  |   3 +
 tools/verification/rv/include/rv.h         |  12 +
 tools/verification/rv/include/trace.h      |  16 +
 tools/verification/rv/include/utils.h      |   8 +
 tools/verification/rv/src/in_kernel.c      | 698 +++++++++++++++++++++
 tools/verification/rv/src/rv.c             | 188 ++++++
 tools/verification/rv/src/trace.c          | 133 ++++
 tools/verification/rv/src/utils.c          |  47 ++
 20 files changed, 1646 insertions(+)
 create mode 100644 Documentation/tools/rv/Makefile
 create mode 100644 Documentation/tools/rv/common_appendix.rst
 create mode 100644 Documentation/tools/rv/common_ikm.rst
 create mode 100644 Documentation/tools/rv/index.rst
 create mode 100644 Documentation/tools/rv/rv-list.rst
 create mode 100644 Documentation/tools/rv/rv-mon-wip.rst
 create mode 100644 Documentation/tools/rv/rv-mon-wwnr.rst
 create mode 100644 Documentation/tools/rv/rv-mon.rst
 create mode 100644 Documentation/tools/rv/rv.rst
 create mode 100644 tools/verification/rv/Makefile
 create mode 100644 tools/verification/rv/README.txt
 create mode 100644 tools/verification/rv/include/in_kernel.h
 create mode 100644 tools/verification/rv/include/rv.h
 create mode 100644 tools/verification/rv/include/trace.h
 create mode 100644 tools/verification/rv/include/utils.h
 create mode 100644 tools/verification/rv/src/in_kernel.c
 create mode 100644 tools/verification/rv/src/rv.c
 create mode 100644 tools/verification/rv/src/trace.c
 create mode 100644 tools/verification/rv/src/utils.c

-- 
2.37.3

