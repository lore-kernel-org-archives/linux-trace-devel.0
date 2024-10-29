Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 08D2A202F9F
	for <linux-trace-devel@vger.kernel.org>; Tue, 29 Oct 2024 08:01:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730188917; cv=none; b=p3tLTUyEmfdw84XPpsHJDbgVN0OTC9VGZeQm+AkG9NU57KUx4spIzOhblwQYaAvuPOibWPPLLmu/8hljvlJViLYfZ6Cw2ETkFSpkNVLBBoW1FHqizZOznc68VkX2lFzVKYHV91RK3SW9WO/cW9MRlqWEgfRiRZZY0kheCb6oAjY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730188917; c=relaxed/simple;
	bh=gygKEqXtXURUnCpUPXOXFPkv5nN7Xdk2gmwz8vAFPag=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qetTaTL9ryVJGRz0UInDvBCUZUBDD1RAvCLQWKMLjJWnzO2TksoWXNKlXtNwACf1Tea4H26EQJtFUwa+SWpEQyEDnNqqj7LYLzUdxYDwNroYnQqSzwcKdIccvr2epRmTOLBlCPXvU3ZZXMBU5MLLPQcoyjqF9Vqwhlc2IllKXzw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Nmw7u9Hn; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Nmw7u9Hn"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1730188914;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=KPQqvL0DfWtqWZ6us6Jg3DJiuib3ufD5gEfVNXRE4Bk=;
	b=Nmw7u9HnayNErLbojSBSfSia7Zojwk5JJXXrI1kZHS/Cm8VPV2q5tqzTMPu/VEKqjvsHbz
	o6gGE35nWwqBAFaXVCa8zvQawMpVQ2f6rmp6o1gBSEK8kDrb95rNBVphx/hJOTPzSFYLek
	PU+RqcDzQa0QiPBtlXGz4ZAcxNtNE1E=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-493-DH29Edq2PUaXBmXkCTS8yA-1; Tue,
 29 Oct 2024 04:01:50 -0400
X-MC-Unique: DH29Edq2PUaXBmXkCTS8yA-1
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 9BF981955BCF;
	Tue, 29 Oct 2024 08:01:49 +0000 (UTC)
Received: from fedora (unknown [10.45.224.46])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with SMTP id A87E730001A7;
	Tue, 29 Oct 2024 08:01:47 +0000 (UTC)
Received: by fedora (sSMTP sendmail emulation); Tue, 29 Oct 2024 09:01:46 +0100
From: "Jerome Marchand" <jmarchan@redhat.com>
To: Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Cc: Steven Rostedt <rostedt@goodmis.org>,
	Jerome Marchand <jmarchan@redhat.com>
Subject: [PATCH 8/8] trace-cmd record: Check the length of the protocol version received
Date: Tue, 29 Oct 2024 09:01:17 +0100
Message-ID: <20241029080117.625177-9-jmarchan@redhat.com>
In-Reply-To: <20241029080117.625177-1-jmarchan@redhat.com>
References: <20240605134054.2626953-1-jmarchan@redhat.com>
 <20241029080117.625177-1-jmarchan@redhat.com>
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4

In check_protocol_version we compare the protocol version string with
the expected one ("V3") with memcmp(). The received string could be
longer than the constant string used for the comparison. That could
lead to out of range access.

Use the known length of the fixed "V3" string for the comparison and
check that the received protocol version is not too short.

Fixes a OVERRUN error (CWE-119)

Signed-off-by: Jerome Marchand <jmarchan@redhat.com>
---
 tracecmd/trace-record.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tracecmd/trace-record.c b/tracecmd/trace-record.c
index 7e84e897..6e9b4535 100644
--- a/tracecmd/trace-record.c
+++ b/tracecmd/trace-record.c
@@ -3811,7 +3811,7 @@ static void check_protocol_version(struct tracecmd_msg_handle *msg_handle)
 		msg_handle->version = V1_PROTOCOL;
 		tracecmd_plog("Use the v1 protocol\n");
 	} else {
-		if (memcmp(buf, "V3", n) != 0)
+		if (n < 3 || memcmp(buf, "V3", 3) != 0)
 			die("Cannot handle the protocol %s", buf);
 		/* OK, let's use v3 protocol */
 		write(fd, V3_MAGIC, sizeof(V3_MAGIC));
-- 
2.47.0

