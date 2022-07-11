Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4904DC43334
	for <linux-trace-devel@archiver.kernel.org>; Mon, 11 Jul 2022 17:47:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229871AbiGKRru (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 11 Jul 2022 13:47:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48222 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231304AbiGKRre (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 11 Jul 2022 13:47:34 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7F52A72EE6
        for <linux-trace-devel@vger.kernel.org>; Mon, 11 Jul 2022 10:47:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 17ED06135B
        for <linux-trace-devel@vger.kernel.org>; Mon, 11 Jul 2022 17:47:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 45B1AC341C8
        for <linux-trace-devel@vger.kernel.org>; Mon, 11 Jul 2022 17:47:18 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
        dkim=fail reason="signature verification failed" (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="Tv/hAJgN"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding; s=pp1;
 bh=L6nK1HTJs3obWwk+ljZ2j3Y10HjNuq9KKzXTw1l0KDE=;
 b=Tv/hAJgNy1ixv4f5zFLTxZAYPzy9s937mprmLKB3aMMrdGTGgwW9GXk6EMwLiLxD7DP1
 PBN+I4fZGjx652GQNoIEtuegHTEsRn0/9Jnrl37XoDLPvM8Ca+6iZVwIn+YaDt0Xoyec
 9/DdxXdkTMJhk5jLMZFFiCyqkFjwZLgBUyLpehoUhkIoPfmAb4Jwm6VQXzq4Lx6YQpZF
 eL2xi1p9voCyamOyA+LLtblQwPyQEkdJVAo3NOmlNc7jUs+4JXP3w+vv5Qn4+4ToPmHD
 VF1kOy1nUs9mTl7n3W100sz/5zF8EXvtaPil//XqzR9WVk6FNo+3VVuun35/Lh3d1RZK MA== 
From:   Sven Schnelle <svens@linux.ibm.com> (by way of Steven Rostedt
        <rostedt@goodmis.org>)
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     Tzvetomir Stoyanov <tz.stoyanov@gmail.com>,
        linux-s390@vger.kernel.org
Date:   Mon, 11 Jul 2022 11:43:40 +0200
Message-Id: <20220711094340.2829115-1-svens@linux.ibm.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: EcQeJhc4DR1fkrtSwK_UsWcyF3dAmAs-
X-Proofpoint-ORIG-GUID: l_5IjszsdpqNZzwM3MOs3nFNb7yKApai
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-07-11_15,2022-07-08_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0 suspectscore=0
 clxscore=1015 impostorscore=0 phishscore=0 priorityscore=1501
 mlxlogscore=853 bulkscore=0 spamscore=0 lowpriorityscore=0 mlxscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2206140000 definitions=main-2207110040
Subject: [PATCH v2] trace-cmd: fix writing of uncompressed size
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

pointer in struct tracecmd_compression is 'unsigned long', which is 8 byte
in size on most platforms, but the tep_read_number() call in the next line
treats it as a 4 byte value. As there's no need for unsigned long change
the type to unsigned int.

Fixes: 3f8447b1 ("trace-cmd library: Add support for compression algorithms")
Signed-off-by: Sven Schnelle <svens@linux.ibm.com>
---
 lib/trace-cmd/trace-compress.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/lib/trace-cmd/trace-compress.c b/lib/trace-cmd/trace-compress.c
index a63295e..461de8d 100644
--- a/lib/trace-cmd/trace-compress.c
+++ b/lib/trace-cmd/trace-compress.c
@@ -32,7 +32,7 @@ struct tracecmd_compression {
 	int				fd;
 	unsigned int			capacity;
 	unsigned int			capacity_read;
-	unsigned long			pointer;
+	unsigned int			pointer;
 	char				*buffer;
 	struct compress_proto		*proto;
 	struct tep_handle		*tep;
-- 
2.36.1
