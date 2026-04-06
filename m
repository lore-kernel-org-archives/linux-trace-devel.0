Received: from m16.mail.163.com (m16.mail.163.com [117.135.210.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6CC8438759D
	for <linux-trace-devel@vger.kernel.org>; Mon,  6 Apr 2026 16:53:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=117.135.210.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775494435; cv=none; b=iixQ7w8YDhQWZJpFJa9jGx/9U8yWK5q482BWq14kzzvYbTfY4hBm9o6hphEkoT4J76iN7t33ekwl4DUnkry7gY7quxvlhDwHRHPCxgx2gQgaQAt7ISAUEOOAeVmFFvEme/eddVWicpDJ6xOik1EtevHewMx3DJuFD4il7vde5RY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775494435; c=relaxed/simple;
	bh=alFR3Fa5fTLlUhx6V3+qK0+ICCmHu7D6DknZZ9BdxKo=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=a85PlUq8pxnrW4ElhwEDyzcNDFtB8zjcO4if7zTicmKsw3D9Nr3ku8/4B6P29J4qdnwuCKKtu9BcExWBmLV7mSS2mAkerfyMqdpZ5DPdtG6BI0kavRwZa+5Z5tepTZy6Qn29EqLvNoSzR+ZGA7MaoVtJFW10oSs8qd6C1+K6QXQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com; spf=pass smtp.mailfrom=163.com; dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b=ajapMMEf; arc=none smtp.client-ip=117.135.210.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=163.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b="ajapMMEf"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-Id:MIME-Version; bh=n9
	MDNsTWQBkUKgXAZAZ6bmYs2kqyedBuaglM3D8/wKg=; b=ajapMMEfY3eVGJHmEs
	+X3e4s3mAlqK2Chbwi1EayeWcj6TD134r8jFMTHzkUyJSPQ1l5RIn4KgS3JTTALO
	FSlqUZ/jjpwHvXfKAOMR1htduZpM4sAA0UPttxula/8FKIRDbbUPjZZcaJnAy0t/
	6GNfKmTs7XUmEAPGACEwe/ZxA=
Received: from localhost.localdomain (unknown [])
	by gzga-smtp-mtada-g0-0 (Coremail) with SMTP id _____wB3PqMT5dNpuXVxDQ--.35566S2;
	Tue, 07 Apr 2026 00:53:40 +0800 (CST)
From: Cao Ruichuang <create0818@163.com>
To: rostedt@goodmis.org
Cc: linux-trace-devel@vger.kernel.org
Subject: [PATCH v2] trace-cmd report: Add spacing before raw data flags
Date: Tue,  7 Apr 2026 00:53:33 +0800
Message-Id: <20260406165333.46051-1-create0818@163.com>
X-Mailer: git-send-email 2.39.5 (Apple Git-154)
In-Reply-To: <20260406153221.33256-1-create0818@163.com>
References: <20260406153221.33256-1-create0818@163.com>
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:_____wB3PqMT5dNpuXVxDQ--.35566S2
X-Coremail-Antispam: 1Uf129KBjvdXoWrZr4UAFWDtr4xGFW8urW5Awb_yoWDArXEqw
	4kJa1jgw4DGF9rA343tryY9r1Utrs8ury5ArWFqFWDZ348Ar18XFZ0vwsxJryxJwsIqFW7
	K3sIq34rta13CjkaLaAFLSUrUUUUjb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
	9fnUUvcSsGvfC2KfnxnUUI43ZEXa7IUb1lk3UUUUU==
X-CM-SenderInfo: pfuht3jhqyimi6rwjhhfrp/xtbC6BXNB2nT5RUd0QAA3x

In raw report mode, the CPU field is followed immediately by the
raw data flags. Without a separator, the flags get glued to the
closing CPU bracket and the output becomes hard to parse visually.

Add a leading space before the raw flag field so the raw report
output keeps the same field separation that the non-raw path already
has.

Link: https://bugzilla.kernel.org/show_bug.cgi?id=221303
Signed-off-by: Cao Ruichuang <create0818@163.com>
---
 tracecmd/trace-read.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tracecmd/trace-read.c b/tracecmd/trace-read.c
index 355ee0f4..962ebd89 100644
--- a/tracecmd/trace-read.c
+++ b/tracecmd/trace-read.c
@@ -871,7 +871,7 @@ void trace_show_data(struct tracecmd_input *handle, struct tep_record *record)
 			TEP_PRINT_CPU);
 
 	if (raw_format)
-		trace_seq_printf(&s, "-0x%x",
+		trace_seq_printf(&s, " -0x%x",
 				 tep_data_flags(pevent, record));
 	else
 		tep_print_event(pevent, &s, record,
-- 
2.39.5 (Apple Git-154)

