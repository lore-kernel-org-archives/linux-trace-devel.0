Return-Path: <linux-trace-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D28EDC00528
	for <linux-trace-devel@archiver.kernel.org>; Fri,  4 Aug 2023 09:52:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230505AbjHDJwy (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 4 Aug 2023 05:52:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51888 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231217AbjHDJwx (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 4 Aug 2023 05:52:53 -0400
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0E9332118;
        Fri,  4 Aug 2023 02:52:52 -0700 (PDT)
Received: from kwepemi500015.china.huawei.com (unknown [172.30.72.55])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4RHLb44L5MzrS8n;
        Fri,  4 Aug 2023 17:51:44 +0800 (CST)
Received: from [10.174.176.219] (10.174.176.219) by
 kwepemi500015.china.huawei.com (7.221.188.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27; Fri, 4 Aug 2023 17:52:49 +0800
To:     <linux-trace-users@vger.kernel.org>,
        <linux-trace-devel@vger.kernel.org>
From:   Lv Ying <lvying6@huawei.com>
Subject: How to solve the coupling between libtraceevent and kernel trace?
CC:     "Fangxiuning (Jack, EulerOS)" <fangxiuning@huawei.com>
Message-ID: <4767bcf3-589a-9dfb-5b45-9ac9279f08e6@huawei.com>
Date:   Fri, 4 Aug 2023 17:52:48 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.174.176.219]
X-ClientProxiedBy: dggems704-chm.china.huawei.com (10.3.19.181) To
 kwepemi500015.china.huawei.com (7.221.188.92)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Hi, all:

I am a rasdaemon developer which depeneds on libtraceevent to parse 
kernel trace events. There is coupling between libtraceevnt and kernel 
trace, if something in libtraceevent and kernel does not match, which 
will cause libtraceevent parse wrong thing. e.g 
https://github.com/mchehab/rasdaemon/pull/98

We also encounter similar problem:
* libtrace(old) KBUFFER_TYPE_TIME_STAMP size = 12
* kernel(new) KBUFFER_TYPE_TIME_STAMP size = 8
Such mismatch will cause strange behavior when parsing trace events.

So if libtraceevent is released out of(independent) kernel, how does 
libtraceevnt to keep compatible with the running kernel(maybe not the 
newest)?

-- 
Thanks!
Lv Ying
