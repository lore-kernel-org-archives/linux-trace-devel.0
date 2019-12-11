Return-Path: <SRS0=a1Iv=2B=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.0 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 70D62C43603
	for <linux-trace-devel@archiver.kernel.org>; Wed, 11 Dec 2019 13:01:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BBB682077B
	for <linux-trace-devel@archiver.kernel.org>; Wed, 11 Dec 2019 13:01:07 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=duncanthrax.net header.i=@duncanthrax.net header.b="T8GaJY71"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729225AbfLKNBH (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 11 Dec 2019 08:01:07 -0500
Received: from shroom.duncanthrax.net ([178.63.180.169]:59223 "EHLO
        smtp.duncanthrax.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727402AbfLKNBH (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 11 Dec 2019 08:01:07 -0500
X-Greylist: delayed 1668 seconds by postgrey-1.27 at vger.kernel.org; Wed, 11 Dec 2019 08:01:06 EST
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=duncanthrax.net; s=dkim; h=Content-Type:MIME-Version:Message-ID:Subject:To:
        From:Date:Sender:Reply-To:Cc:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:
        List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=oBMbXE8UpvXasjY1ZiOIc3DodwQGPRx/7lOyYb3GBHY=; b=T8GaJY719OTQybRw1nBWMBRO0S
        GmfHwfBSDg+pw1nPCQ7wByFHqHqZQZiYUDohRyR927vC1xGg5FcImHdJV4Y3i2AqrvAr9Q5gnxAsA
        ji3uY8cDxi3faBqhdcKoQE6I8LbNM01DuICCjLAkjDUjz2KiUOf720HGtLfHAdNw90x8=;
Received: from [2a01:4f8:121:41fa::170] (helo=stackframe.org)
        by smtp.duncanthrax.net with esmtpa (Exim 4.90_1)
        (envelope-from <svens@stackframe.org>)
        id 1if1B6-0003Hb-SC
        for linux-trace-devel@vger.kernel.org; Wed, 11 Dec 2019 13:33:17 +0100
Date:   Wed, 11 Dec 2019 13:33:16 +0100
From:   Sven Schnelle <svens@stackframe.org>
To:     linux-trace-devel@vger.kernel.org
Subject: ftrace histogram sorting broken on BE architecures
Message-ID: <20191211123316.GD12147@stackframe.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Hi List,

i was looking into a ftracetest failure on s390:

# ./ftracetest test.d/trigger/trigger-hist.tc
=== Ftrace unit tests ===
[1] event trigger - test histogram trigger	[FAIL]
[2] (instance)  event trigger - test histogram trigger	[FAIL]

from the -vvv log: ++ fail 'sort param on sched_process_fork did not work'

# cat events/sched/sched_process_fork/hist

# event histogram
#
# trigger info: hist:keys=parent_pid,child_pid:vals=hitcount:sort=child_pid:size=2048 [active]
#

{ parent_pid:       1406, child_pid:       1428 } hitcount:          1
{ parent_pid:       1406, child_pid:       1430 } hitcount:          1
{ parent_pid:       1406, child_pid:       1427 } hitcount:          1
{ parent_pid:       1406, child_pid:       1432 } hitcount:          1
{ parent_pid:       1406, child_pid:       1431 } hitcount:          1
{ parent_pid:       1406, child_pid:       1429 } hitcount:          1

So the test is right, the entries are not sorted. After digging into the
ftrace code i noticed that integer values always get extended to 64 bit
in event_hist_trigger(), but cmp_entries_key() from tracing_map.c uses the
type of the field (which is a pid_t, and therefore 4 bytes).

On Little Endian this doesn't hurt, but on BE s390 this makes the compare
function compare 4 zero bytes, which is the reason why sorting doesn't
work. As a test i forced the compare function used in cmp_entries_key() to
tracing_map_cmp_s64(), which made the ftrace tests pass.

I also tested this on 64 bit parisc with the same results, so the architecture
doesn't seem make a difference (besides LE vs. BE)

Any thoughts on how to fix this? I'm not sure whether i fully understand the
ftrace maps... ;-)

Best,
Sven
