Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6507BC433ED
	for <linux-trace-devel@archiver.kernel.org>; Wed, 12 May 2021 13:52:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2EB6F611AC
	for <linux-trace-devel@archiver.kernel.org>; Wed, 12 May 2021 13:52:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230347AbhELNxJ (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 12 May 2021 09:53:09 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:52731 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230328AbhELNxJ (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 12 May 2021 09:53:09 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1620827520;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=XhYIEP5mFTqCoRyBcVXNFVTDW8cxjr0qqEaD2am8654=;
        b=L0TWOO1m8dANEVilnyBb0RUjx8dJU/6jIces60CFIDIgdonH9a+QJve+GJ4NE2prWBOnKv
        MA/za4vHUAXp32I9lpm2bdC72C3PucQjG7/RFx/FlSb1X099K8TczLLN3wCLJt2SOkCJeC
        dg3CXogzXR45Z+LSgif6/xG/l9PoEEc=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-581-xK9HZFAPPZOJBC-pGtVANQ-1; Wed, 12 May 2021 09:51:58 -0400
X-MC-Unique: xK9HZFAPPZOJBC-pGtVANQ-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 035BF101371E;
        Wed, 12 May 2021 13:51:57 +0000 (UTC)
Received: from [10.40.208.59] (unknown [10.40.208.59])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id C5B172B9FA;
        Wed, 12 May 2021 13:51:55 +0000 (UTC)
To:     linux-trace-devel@vger.kernel.org
From:   Jerome Marchand <jmarchan@redhat.com>
Cc:     Tzvetomir Stoyanov <tz.stoyanov@gmail.com>,
        Steven Rostedt <rostedt@goodmis.org>
Subject: trace-cmd profile is not working
Message-ID: <8c1d353e-05d5-d789-00a2-de94d705950e@redhat.com>
Date:   Wed, 12 May 2021 15:51:52 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Hi,

Streams, and thus trace-cmd profile, are not working. A simple
"trace-cmd profile ls" command exit with the following message
"Creating stream for 0". I've been looking at it and the issue is that 
tracecmd_read_headers() tries to read the cmdlines, cpus and options 
sections that have not been written to the temporary file when called 
from trace_stream_init().

AFAICT, it is caused by the two following patches:

commit 1eea02a4 ("trace-cmd: Write saved cmdlines in the trace file at
the end of the trace.") which moved the writing of cmdlines from
create_file_fd() to tracecmd_create_file_latency() and
tracecmd_append_cpu_data()

commit 5d4d7ec3 ("trace-cmd: Move reading of trace.dat options to
tracecmd_read_headers()") which moved the reading of options and cpu
datas to tracecmd_read_headers().

Thanks,
Jerome

