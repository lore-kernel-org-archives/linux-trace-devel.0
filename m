Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 178B41401C
	for <linux-trace-devel@vger.kernel.org>; Thu,  5 Dec 2024 14:45:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733409914; cv=none; b=rV8rrpXcNtDK1QUIcaRJDRQfS/0KpXD7auErjF8CxA0mi4f2kIDftWFedzEz1Vj7UwjQthciFMKFWfeMqP9PAjMmcLpcYEZ9yNft5mhem4S8Wadhl+/CI3aw14x4aIxFRbzymsqm5jrjFzMUB/eSUdZyqfmJ6C8sXKY2zFxxYR4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733409914; c=relaxed/simple;
	bh=LNpOsTTQsy+sMzrNAXn2s/SJbQJMVL2n0YF3za1Mbfk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WUMbih1tDe3Lo0MB3bhi4wiPlBzqmc7dS2cOnQPvQNcMITnfM492egO2swK2u5fz2qVP1Xr10b2NTAQ88F49nZyUKzL8K0I/dL/5mmCPUzuCskU7Rh6mabNXGCsAMJTLVIqIZPp2BTr7lA1mpGihzdFqfX1O8NgksS1If40HeSc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=BhUQlwpO; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="BhUQlwpO"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1733409912;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ck1+zShcNyFzXD+JlRIKbTR6NQsQ4a5lOa5thmAmLjI=;
	b=BhUQlwpOYOWE4KKTAY6e7QcGJ1UNjlVCyd2KCPukWBBOEvdCzXFwVambR48yNINLXzdBvM
	+KwGdT9wQmfMSE3szWo7ALDrgSmWBhekoB3D/pGen7EzyJ/Y1dfbDZDHbQioVRQr+xxPIk
	L3/H2Y8MYBFK9un5C1evfIncrgTS4aI=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-373-CiyzIqiEOCe2CqwolXo_QQ-1; Thu,
 05 Dec 2024 09:45:09 -0500
X-MC-Unique: CiyzIqiEOCe2CqwolXo_QQ-1
X-Mimecast-MFC-AGG-ID: CiyzIqiEOCe2CqwolXo_QQ
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 3C2CF1956095;
	Thu,  5 Dec 2024 14:45:08 +0000 (UTC)
Received: from fedora (unknown [10.43.17.16])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with SMTP id 3E6BE3000197;
	Thu,  5 Dec 2024 14:45:06 +0000 (UTC)
Received: by fedora (sSMTP sendmail emulation); Thu, 05 Dec 2024 15:45:04 +0100
From: "Jerome Marchand" <jmarchan@redhat.com>
To: Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Cc: Steven Rostedt <rostedt@goodmis.org>,
	Jerome Marchand <jmarchan@redhat.com>
Subject: [PATCH 7/7] trace-cmd record: Fix stdin redirection to /dev/null
Date: Thu,  5 Dec 2024 15:44:39 +0100
Message-ID: <20241205144439.127564-8-jmarchan@redhat.com>
In-Reply-To: <20241205144439.127564-1-jmarchan@redhat.com>
References: <20241205144439.127564-1-jmarchan@redhat.com>
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4

In daemonize_start(), stdin file descriptor is closed after the call
to dup2. This doesn't make sense and could lead to FD zero being
reused. I assume the original intend was to close the devnull FD which
in the current code remains opened while the devnull variable goes out
of scope.

Close devnull instead of 0.

Signed-off-by: Jerome Marchand <jmarchan@redhat.com>
---
 tracecmd/trace-record.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tracecmd/trace-record.c b/tracecmd/trace-record.c
index 6e9b4535..fe9ceaa8 100644
--- a/tracecmd/trace-record.c
+++ b/tracecmd/trace-record.c
@@ -1677,7 +1677,7 @@ static void daemonize_start(void)
 		if (devnull > 0) {
 			if (dup2(devnull, 0) == -1)
 				die("daemonize: dup2");
-			close(0);
+			close(devnull);
 		}
 
 		return;
-- 
2.47.0

