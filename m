Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0015DC433F5
	for <linux-trace-devel@archiver.kernel.org>; Wed,  2 Mar 2022 19:02:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244795AbiCBTC6 convert rfc822-to-8bit (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 2 Mar 2022 14:02:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32884 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244785AbiCBTC4 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 2 Mar 2022 14:02:56 -0500
Received: from us-smtp-delivery-44.mimecast.com (us-smtp-delivery-44.mimecast.com [205.139.111.44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id A5C8E45041
        for <linux-trace-devel@vger.kernel.org>; Wed,  2 Mar 2022 11:02:12 -0800 (PST)
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-252-PLIH9pRyO2SBN5CvXSprTQ-1; Wed, 02 Mar 2022 14:02:07 -0500
X-MC-Unique: PLIH9pRyO2SBN5CvXSprTQ-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id A3ED11091DA1;
        Wed,  2 Mar 2022 19:02:06 +0000 (UTC)
Received: from x1.com (unknown [10.22.32.168])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 3144F19C59;
        Wed,  2 Mar 2022 19:01:43 +0000 (UTC)
From:   Daniel Bristot de Oliveira <bristot@kernel.org>
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     Daniel Bristot de Oliveira <bristot@kernel.org>,
        Jonathan Corbet <corbet@lwn.net>,
        Clark Williams <williams@redhat.com>,
        Juri Lelli <juri.lelli@redhat.com>, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-trace-devel@vger.kernel.org
Subject: [PATCH V3 00/15] rtla: Improved tracing support
Date:   Wed,  2 Mar 2022 20:01:25 +0100
Message-Id: <cover.1646247211.git.bristot@kernel.org>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Authentication-Results: relay.mimecast.com;
        auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=bristot@kernel.org
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: kernel.org
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset=WINDOWS-1252
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

This set introduces some tracing facilities to rtla tools:

- Add the possibility to change the tracing_thresh to osnoise,
allowing a fine tune of OS noise detection.

- Add the auto-tracing feature (-a threshold us), which aims
helping the first approach to a problem by setting common
tracing features with a single parameter.

- Add -e/--event option, allowing osnoise and timerlat to
enable additional trace events via (possible multiple)
-e sys:event options.

- Add the --filter option to filter the previous -e event.

- Add the --trigger option to allow the usage of tracing
trigger of the previously set -e event. If the trigger
is hist: one, rtla automatically saves the hist file
associated with the -e event.

And some more improvements:

- Add --dma-latency option to tune exit from idle latencies

- Some minor fixes

Changes from V2:
 - Rebased to for-next
 - Add --dma-latency
 - Some more fixes
Changes from V1:
 - Add -e to osnoise/timerlat hist
 - Add --trigger
 - Add --filter
 - Add support to save hist file
 - Function name refactoring

Daniel Bristot de Oliveira (15):
  rtla/osnoise: Add support to adjust the tracing_thresh
  rtla/osnoise: Add an option to set the threshold
  rtla/osnoise: Add the automatic trace option
  rtla/timerlat: Add the automatic trace option
  rtla/trace: Add trace events helpers
  rtla: Add -e/--event support
  rtla/trace: Add trace event trigger helpers
  rtla: Add --trigger support
  rtla/trace: Add trace event filter helpers
  rtla: Add --filter support
  rtla/trace: Save event histogram output to a file
  rtla: Check for trace off also in the trace instance
  rtla/osnoise: Fix osnoise hist stop tracing message
  rtla/timerlat: Add --dma-latency option
  rtla: Tools main loop cleanup

 Documentation/tools/rtla/common_options.rst   |  19 +
 .../tools/rtla/common_osnoise_options.rst     |  10 +
 .../tools/rtla/common_timerlat_options.rst    |  12 +
 tools/tracing/rtla/src/osnoise.c              |  83 +++++
 tools/tracing/rtla/src/osnoise.h              |   8 +
 tools/tracing/rtla/src/osnoise_hist.c         |  95 ++++-
 tools/tracing/rtla/src/osnoise_top.c          |  91 ++++-
 tools/tracing/rtla/src/timerlat_hist.c        | 108 +++++-
 tools/tracing/rtla/src/timerlat_top.c         | 103 +++++-
 tools/tracing/rtla/src/trace.c                | 345 ++++++++++++++++++
 tools/tracing/rtla/src/trace.h                |  23 ++
 tools/tracing/rtla/src/utils.c                |  33 ++
 tools/tracing/rtla/src/utils.h                |   1 +
 13 files changed, 903 insertions(+), 28 deletions(-)

-- 
2.34.1

