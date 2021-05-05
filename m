Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=BAYES_40,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 63A4FC433B4
	for <linux-trace-devel@archiver.kernel.org>; Wed,  5 May 2021 09:54:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 27DF561008
	for <linux-trace-devel@archiver.kernel.org>; Wed,  5 May 2021 09:54:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232381AbhEEJzm (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 5 May 2021 05:55:42 -0400
Received: from 7.mo173.mail-out.ovh.net ([46.105.44.159]:34880 "EHLO
        7.mo173.mail-out.ovh.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231769AbhEEJzm (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 5 May 2021 05:55:42 -0400
X-Greylist: delayed 8736 seconds by postgrey-1.27 at vger.kernel.org; Wed, 05 May 2021 05:55:41 EDT
Received: from player761.ha.ovh.net (unknown [10.109.156.38])
        by mo173.mail-out.ovh.net (Postfix) with ESMTP id C4C2E16D107
        for <linux-trace-devel@vger.kernel.org>; Wed,  5 May 2021 09:29:08 +0200 (CEST)
Received: from sterchelen.net (lfbn-cae-1-333-239.w90-22.abo.wanadoo.fr [90.22.52.239])
        (Authenticated sender: nicolas@sterchelen.net)
        by player761.ha.ovh.net (Postfix) with ESMTPSA id 3D6CB1DD311DF
        for <linux-trace-devel@vger.kernel.org>; Wed,  5 May 2021 07:29:08 +0000 (UTC)
Authentication-Results: garm.ovh; auth=pass (GARM-95G0013f243cb0-d575-4c73-973b-bb13d84b5510,
                    577A1C58B11FA958503A8C07E87E3B09E51EAB4A) smtp.auth=nicolas@sterchelen.net
X-OVh-ClientIp: 90.22.52.239
Date:   Wed, 5 May 2021 09:28:23 +0200
From:   Nicolas Sterchele <nicolas@sterchelen.net>
To:     linux-trace-devel@vger.kernel.org
Subject: Record until a function call
Message-ID: <YJJJF6bu84uZ/B39@groot>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
X-Ovh-Tracer-Id: 5279344667092421506
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: 0
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrgeduledrvdefjedgudduhecutefuodetggdotefrodftvfcurfhrohhfihhlvgemucfqggfjpdevjffgvefmvefgnecuuegrihhlohhuthemucehtddtnecunecujfgurhepfffhvffukfggtggugfesthekredttddtjeenucfhrhhomheppfhitgholhgrshcuufhtvghrtghhvghlvgcuoehnihgtohhlrghssehsthgvrhgthhgvlhgvnhdrnhgvtheqnecuggftrfgrthhtvghrnhepueffkeevgfevfefhhfffiedtkeelgffggffgtdeuffeghefhieeiueethfegudfhnecukfhppedtrddtrddtrddtpdeltddrvddvrdehvddrvdefleenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhhouggvpehsmhhtphdqohhuthdphhgvlhhopehplhgrhigvrhejiedurdhhrgdrohhvhhdrnhgvthdpihhnvghtpedtrddtrddtrddtpdhmrghilhhfrhhomhepnhhitgholhgrshesshhtvghrtghhvghlvghnrdhnvghtpdhrtghpthhtoheplhhinhhugidqthhrrggtvgdquggvvhgvlhesvhhgvghrrdhkvghrnhgvlhdrohhrgh
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Hi there,

I did not find any options permitting to record a trace until a function has been called.

For instance, you want to record every function calls of a specific
process until a specific function has been called.
Before doing this development, I would like to have your thoughts on
this use case? Or if it is already possible?

thx.

-- 
Nicolas Sterchele
/ni.kɔ.lɑ/ /stɛrʃɛl/
@sterchelen
