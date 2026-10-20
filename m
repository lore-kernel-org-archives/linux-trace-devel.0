Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=216.40.44.14
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792520896;
	b=uf8HMCSOrxqjBBAp5NjIDxTtyvMFlqGt0XFlz4nnda6humASnJJsNfj8Xl1YRn9nfRn/
	 wt1wJ/YOO3su2ACilSzIpQ9DIJ9uLXCrnA0N4cTUqRiZg1wJNneIyIA5fIC1mxzaADRMy
	 DsnC14NdVvWqDLBuMMyDIQMB1Gd1PCcXzKbX54ybghj+D7apz3yVersGHs6wJJ/a6TIk9
	 HY3ZpOGZHtLa9SU9EsPcmk2E9U55j/DPcoGMhOutcx2vSmw+o5TIew8JC1v2GMSacX/mB
	 DyRp+6MO3OJcdFioIS7WhWx6SgGeYrGpOVPrXfHNDCP5KUcTx0488QaISeloHheiWyQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792520896;
	h=DMARC-Filter:Received:Received:Date:From:To:Subject:Message-ID:
	 X-Mailer:MIME-Version:Content-Type:Content-Transfer-Encoding:
	 X-Rspamd-Server:X-Rspamd-Queue-Id:X-Stat-Signature:X-Spam-Status:
	 X-Session-Marker:X-Session-ID:DKIM-Signature:X-HE-Tag:X-HE-Meta;
	bh=RdkDVmNDZz8OkwkelCzyrcOfUsE9kfW5eqWRQl9yZQo=;
	b=wcf2mXTAikLExkzs6T6OviJ7HOt2gky8LCIXH/sbCBPEH41Jm9jccFayzTcHnIfy2TpD
	 zIJblieqH9YRhpCJpmBAm7u7szkME/hwS+3lgI2uZ5dIlgKMtkKeFeCuApiEu6ZJVbZPi
	 /CksrRsugQgz2hFCEOail3khse2eyAuJQpXeWMspQ94YY44AuqkNirwgnHl+4vrc/zY/n
	 I3h+mtJvcdZCBIDfPznKROg7KEYRTgR0jGyc65ahJr5mGGGZFdvKNSWL8KOCImejEaENr
	 xCxaagR8Rfb65DOYI0TdIJvA7Vuv1FFhUs0Myi3nTBb1UKNyyrCIy/081rt3XctdP6Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=goodmis.org;
	spf=pass smtp.mailfrom=goodmis.org;
	dkim=pass header.d=goodmis.org header.i=@goodmis.org header.a=rsa-sha256 header.s=dkim1 header.b=D5rIYFV7;
	arc=none smtp.remote-ip=216.40.44.14
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE239606A31B
	for <linux-trace-devel@vger.kernel.org>; Tue, 20 Oct 2026 18:28:15 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org AE239606A31B
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=goodmis.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=goodmis.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=goodmis.org header.i=@goodmis.org header.a=rsa-sha256 header.s=dkim1 header.b=D5rIYFV7
Received: from omf16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id A860F140340
	for <linux-trace-devel@vger.kernel.org>; Tue, 20 Oct 2026 18:28:14 +0000 (UTC)
Received: from [HIDDEN] (Authenticated sender: rostedt@goodmis.org) by omf16.hostedemail.com (Postfix) with ESMTPA id 6E3162000F
	for <linux-trace-devel@vger.kernel.org>; Tue, 20 Oct 2026 18:28:13 +0000 (UTC)
Date: Tue, 20 Oct 2026 14:28:07 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Subject: [PATCH] trace-cmd record: Do not delete buffers that already exist
Message-ID: <20261020142807.1e8b1d63@gandalf.local.home>
X-Mailer: Claws Mail 3.20.0git84 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Post: <mailto:linux-trace-devel@vger.kernel.org>
List-Help: <mailto:linux-trace-devel+help@vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-trace-devel+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspamout05
X-Rspamd-Queue-Id: 6E3162000F
X-Stat-Signature: n9999bd6b7dug3e5sqr3qzrw7qzwzxof
X-Session-Marker: 726F737465647440676F6F646D69732E6F7267
X-Session-ID: U2FsdGVkX1+g4Jo6P4yXku/Irouf+TGZ6NoqsZ0+rdo=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=goodmis.org; h=date:from:to:subject:message-id:mime-version:content-type:content-transfer-encoding; s=dkim1; bh=RdkDVmNDZz8OkwkelCzyrcOfUsE9kfW5eqWRQl9yZQo=; b=D5rIYFV71LiepIIOJHXTdV0HN91rWB79RUMv1Xthlwykn40vNs3nepbX9InnjpahNkaueiXvTEE+npdHJcWW5/Hre8nH1AkKPzhc1wFVAwz7h+wd1c14PcDJPVGLJCNxKyYjeiSk7eO2RmlGCPPQTgPhBy3c52Na96GVEZ9oXq0=
X-HE-Tag: 1792520893-478046
X-HE-Meta: U2FsdGVkX19XZ8Io1CI68TdZtBnT0U7bpA4OoZynWfsgiiOD12nRH7McrfVOTEo+KpHAIjcBlcCVTTXNgGdP9m3A2XbV1r8QIqjguzdDEHe4J24C6VCWc8VHpATVx/UwcDOyYvlcgtuGLR4mxocrXXAY5U8Q9KSErZP4QnHUZm2w6pKzARlsrAtC4/1st548g9/3obiw36FQPDlru1cEBFfFPBGWIw0E9sCkAwPqkALnpuAT5nZX84i7fpC8XOjaX0mApP0h1vgVIDkK4VjhbNUvGrSgTB3QwNr/Pji4QmSJcVKFmGaMlnK8O1zmQdZD5ASKLXFTy3oqC/PNySb8mVY1zYrjoJSsNt+5d0mdMDC/udvgWswNjfHZHP2owLES

From: Steven Rostedt <rostedt@goodmis.org>

When recording if -B foo is used and foo already exists, it will be deleted
when the record is finished. This is because the creation and allocation was
combined and the addition of the BUFFER_FL_KEEP flags was missed in one of
the places the instance was allocated and not created.

Fixes: 49b36d72b ("libtracefs: Combine allocate and create APIs into one")
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 tracecmd/trace-record.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/tracecmd/trace-record.c b/tracecmd/trace-record.c
index e7bb2f58ac4d..1ee3effca114 100644
--- a/tracecmd/trace-record.c
+++ b/tracecmd/trace-record.c
@@ -384,6 +384,7 @@ struct buffer_instance *allocate_instance(const char *name)
 		instance->tracefs = tracefs_instance_create(name);
 		if (!instance->tracefs)
 			goto error;
+		instance->flags |= BUFFER_FL_KEEP;
 	}
 
 	return instance;
-- 
2.53.0

