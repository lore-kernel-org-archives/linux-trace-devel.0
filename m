Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 56D70193094
	for <linux-trace-devel@vger.kernel.org>; Wed,  5 Jun 2024 13:42:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717594941; cv=none; b=WU+z0giBA7It8KscyU9q0EgdestsWgiyVW9omOnyGCn4ap4+fghsdCQ1oUk8+BYint+DNNpnFSG2OUBeDnxZSidLDLi9Rg9OKynvbQh5W5EozTPloXGeOY0xQMysZZZbQ9f/34mZ4JJKS3uQEGbhmCm1SRO+7C0TDoyZvcv6Yfk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717594941; c=relaxed/simple;
	bh=2Ge05KBWAfcMya41hDApaCCzf2xreZnZmDHe67BO21k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NynyMejsIJpLsRX/VtpXktFPy9Mv8T8GeQEktiv0F4YD3/7iJO69500HSp/tjGijXF6RrPV1Zug+5te4r0Rr6sPonN0eke8i58Tszzn3XD++wupNt8+wSNUJpqL454dJ3HqzQTG6rpNEexv2H+aAhwkcNFd+Bf52kCwGE7FYWMo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=dk2HCiGI; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="dk2HCiGI"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1717594939;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=2J9RpEfm+P5tNpnFCx5OHAnHnj2zwjI2eSWMoS4B2kI=;
	b=dk2HCiGIcy81ICuWGkvFqknmglojKBHybej2JOm51Ecju7wHwJE6LQZNeD0l8nOMC+sUIb
	q+7vTqJInCA9PWZH3ol9FzmTVyjKuaY+Xlk3NeErm1uSSTtKm1DrzVyXiziwocSk7tsxvq
	ZnasYkg+1UIokM+SLS1OBt8sok1psrI=
Received: from mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-381-ZzFESUS-OvKcXQ1rBmT4AA-1; Wed,
 05 Jun 2024 09:42:14 -0400
X-MC-Unique: ZzFESUS-OvKcXQ1rBmT4AA-1
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 0550A195421D;
	Wed,  5 Jun 2024 13:42:12 +0000 (UTC)
Received: from fedora (unknown [10.45.225.116])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with SMTP id AE1451955DC1;
	Wed,  5 Jun 2024 13:42:09 +0000 (UTC)
Received: by fedora (sSMTP sendmail emulation); Wed, 05 Jun 2024 15:42:08 +0200
From: "Jerome Marchand" <jmarchan@redhat.com>
To: Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Cc: Steven Rostedt <rostedt@goodmis.org>,
	Jerome Marchand <jmarchan@redhat.com>
Subject: [PATCH 20/38] trace-cmd lib: check for a negative return value of read in tracecmd_compress_copy_from()
Date: Wed,  5 Jun 2024 15:40:35 +0200
Message-ID: <20240605134054.2626953-21-jmarchan@redhat.com>
In-Reply-To: <20240605134054.2626953-1-jmarchan@redhat.com>
References: <20240605134054.2626953-1-jmarchan@redhat.com>
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17

Check that read() return a non negative value before adding it to all
in tracecmd_compress_copy_from(). If all == 1 before that, we would
exit the loops thinking it succeeded.

Signed-off-by: Jerome Marchand <jmarchan@redhat.com>
---
 lib/trace-cmd/trace-compress.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/lib/trace-cmd/trace-compress.c b/lib/trace-cmd/trace-compress.c
index e550dbd4..3ca0e21f 100644
--- a/lib/trace-cmd/trace-compress.c
+++ b/lib/trace-cmd/trace-compress.c
@@ -714,10 +714,10 @@ int tracecmd_compress_copy_from(struct tracecmd_compression *handle, int fd, int
 
 		do {
 			r = read(fd, buf_from + all, rchunk - all);
-			all += r;
-
 			if (r <= 0)
 				break;
+
+			all += r;
 		} while (all != rchunk);
 
 
-- 
2.44.0

