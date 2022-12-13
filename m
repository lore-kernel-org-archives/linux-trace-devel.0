Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9C3E7C4332F
	for <linux-trace-devel@archiver.kernel.org>; Tue, 13 Dec 2022 17:02:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235403AbiLMRCX (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 13 Dec 2022 12:02:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60846 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235670AbiLMRBF (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 13 Dec 2022 12:01:05 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E816024F14
        for <linux-trace-devel@vger.kernel.org>; Tue, 13 Dec 2022 08:57:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1670950627;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=fS65/kt7l75QDLmlJktSxVKlNS0rrsh3hEOQy076J6I=;
        b=Bm/ZKwVOwWoq4qFDjah+73rs/LNFRHLHLwKwpwgXyr+wb8GChq81cDXj2SyVCRYAqc2KaF
        Y51pXjWYriK1Z4dxlvT718sTVAGgQrvzjDO82PfJVZiwxjaIJpW6bGQlUDO1sMFj8xhCpO
        3+O5hQk6wdhCFZQoZf+pX29hsOryTP0=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-146-NnhLoGu_NWa97AfjiHD3qw-1; Tue, 13 Dec 2022 11:57:04 -0500
X-MC-Unique: NnhLoGu_NWa97AfjiHD3qw-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 663D33C0F801;
        Tue, 13 Dec 2022 16:57:04 +0000 (UTC)
Received: from vschneid.remote.csb (unknown [10.33.36.185])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 7D5991121318;
        Tue, 13 Dec 2022 16:57:03 +0000 (UTC)
From:   Valentin Schneider <vschneid@redhat.com>
To:     linux-trace-devel@vger.kernel.org
Cc:     Steven Rostedt <rostedt@goodmis.org>,
        Daniel Bristot de Oliveira <bristot@redhat.com>,
        Clark Williams <williams@redhat.com>,
        Douglas RAILLARD <douglas.raillard@arm.com>
Subject: [PATCH v3 0/4] libtraceevent: Handling cpumask event fields
Date:   Tue, 13 Dec 2022 16:56:16 +0000
Message-Id: <20221213165620.1034287-1-vschneid@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.3
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Hi folks,

While discussing around [1], Steve had the idea [2] of creating a "proper" type
for cpumask event fields so that userspace tooling doesn't have to guess whether
an unsigned long [] is meant to be a cpumask or not.

o Patch 1 is a collateral fix found by running the new units tests.
o Patch 2 introduces a small amount of boiler plate to get cpumask fields on the same level 
  as bitmask fields
o Patch 3 adds pretty-print output for cpumasks
o Patch 4 is unit tests for the above

Cheers,
Valentin

Revisions
=========

v2 -> v3
++++++++
o Rebased on top of latest libtraceevent
o Added unit tests (Steven)
o Moved TEP_PRINT_CPUMASK definition to the tail of tep_print_arg_type (Steven)

v1 -> v2
++++++++
o Rebased on top of latest libtraceevent
o Fixed s/__get_cpumask/__get_rel_cpumask/ typo

[1]: http://lore.kernel.org/r/xhsmhilkqfi7z.mognet@vschneid.remote.csb
[2]: http://lore.kernel.org/r/20221014080456.1d32b989@rorschach.local.home

Valentin Schneider (4):
  libtraceevent: Ensure print_field_raw() terminates with '\0'
  libtraceevent: Add boiler-plate code for cpumask types
  libtraceevent: Pretty-print cpumask fields as a cpulist
  libtraceevent: Add unit tests for cpumask processing

 include/traceevent/event-parse.h |   1 +
 src/event-parse.c                | 191 +++++++++++++++++++++++++++++++
 utest/traceevent-utest.c         | 161 ++++++++++++++++++++++++++
 3 files changed, 353 insertions(+)

--
2.31.1

