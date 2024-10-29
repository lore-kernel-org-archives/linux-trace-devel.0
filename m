Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 68B632036E3
	for <linux-trace-devel@vger.kernel.org>; Tue, 29 Oct 2024 08:01:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730188914; cv=none; b=r5YZdGcxkcP7PgdQbkmdGsbYxoF9uYHUV3MTo+NoEnUUwFVjvxmhADpE5TqDQWavxvL8rJHslS6dq6HcBlYIiWJP4plVbuv82qoutKTGBKf1yApMaTnMUF7ugbfWtB5/dqnnY0+SJlOeKs4uT15vV+Pr+Pbr0fw/su4gf5xl65k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730188914; c=relaxed/simple;
	bh=wtEbpwkBsdhYVWXR9FaWVmGbU36x9ZObIi8vIn+vcQk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jEsC2iuYthGcILc0+7Xm/nGuCiMZg9xVH4QBthw5SF6TM2g2gBuM+5zX0n1aePtQzk0qSesBFod9e/ll3kDnOS8AW0Xp1eTd/pESuPoHrchYXUaWybCAc5r3GlEZqPRdx3l91G5Z/LuMbXy6lrR17Bv8FAmCBE3QyOqFhemITSM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=A9jhzmip; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="A9jhzmip"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1730188911;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=jCz59QQqMSxslB6F+LaRs26YFQiOAZUg+f5F0n1+eTk=;
	b=A9jhzmipW/ayvPcEnFGySwbopy9VlcZRgWb2RznFyIZ9ysUhy9+DNeYzsQoXknZ4s5i0g0
	TbAFBmIKnLfhysivf0JenV/3+/AZ9CevA0CXGnScaKQxcNqXfw6xeDqYmo5ivpfTCJncYl
	wBtXYkCUofhyhkQh7tMgs09CSLfYQaU=
Received: from mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-262-t4p7FqkMOpSy1tuoxZrBQg-1; Tue,
 29 Oct 2024 04:01:47 -0400
X-MC-Unique: t4p7FqkMOpSy1tuoxZrBQg-1
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 321811955EAC;
	Tue, 29 Oct 2024 08:01:46 +0000 (UTC)
Received: from fedora (unknown [10.45.224.46])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with SMTP id 4255F19560A3;
	Tue, 29 Oct 2024 08:01:44 +0000 (UTC)
Received: by fedora (sSMTP sendmail emulation); Tue, 29 Oct 2024 09:01:42 +0100
From: "Jerome Marchand" <jmarchan@redhat.com>
To: Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Cc: Steven Rostedt <rostedt@goodmis.org>,
	Jerome Marchand <jmarchan@redhat.com>
Subject: [PATCH 7/8] trace-cmd mem: Prevent a memory leak in trace_mem()
Date: Tue, 29 Oct 2024 09:01:16 +0100
Message-ID: <20241029080117.625177-8-jmarchan@redhat.com>
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
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17

Close the tracecmd handle in the error path.

Fixes a RESOURCE_LEAK error (CWE-772)

Signed-off-by: Jerome Marchand <jmarchan@redhat.com>
---
 tracecmd/trace-mem.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/tracecmd/trace-mem.c b/tracecmd/trace-mem.c
index 3e1ac9f3..b8babbbc 100644
--- a/tracecmd/trace-mem.c
+++ b/tracecmd/trace-mem.c
@@ -554,10 +554,8 @@ void trace_mem(int argc, char **argv)
 		die("can't open %s\n", input_file);
 
 	ret = tracecmd_read_headers(handle, 0);
-	if (ret)
-		return;
-
-	do_trace_mem(handle);
+	if (!ret)
+		do_trace_mem(handle);
 
 	tracecmd_close(handle);
 }
-- 
2.47.0

