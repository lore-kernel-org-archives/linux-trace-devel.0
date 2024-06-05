Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 852B0188CB3
	for <linux-trace-devel@vger.kernel.org>; Wed,  5 Jun 2024 13:42:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717594960; cv=none; b=lP4t2sIyR65pXj7k8kuUZWQQqETkhnOIbCFLUafJgn052wW/a4l1irqUwmvkuwTtSmASyhx5Pt9lAzIaAax05cCdNpUj+gUYgbSU++E9B7VGNGLSiWCjQCnjN3+U/ARBoBVBAaajhQEQJg9UzIqnIEjfpXLFpILaX5LCJIginII=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717594960; c=relaxed/simple;
	bh=WxiEWqjqJvXNeNz6muzQk7gA7aec2o5twqsrH3Wd/F4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gfUAK4jJfShv80461h7jj8KhSRSPv6Hw+yIEz+pMn+bSmRCx494uSBCSBaM7LpqKPQOytaNPpUd2BjMupe/HWIfv9XTkWWFVapnpzSX9chuM6BSswhKg/Z873t8nl2vr758BG2BohjZhYPrOe/2eec7SQ/2mLQdSya78FKK4Fr4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=PWB3k/nQ; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="PWB3k/nQ"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1717594958;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=MNF4zgtfYv1348FEzWn08y7vNfXIO41Jk68YoJT9IJw=;
	b=PWB3k/nQod20KYPIX6K33Vq4oZ0tsZQBMyGVOJYSm7KlWMNVKu9PLrJ94NaelyjyijaBDi
	BUxnjOvIU9/9VYQILYHo5/7M8hBf8sIXzA9WtuZuHzbKY04NOjVz+wzBtTc+Pt4CAJM/7b
	DrtlBCtyaQwrXYL4ka7tDH2LC0blqZ0=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-6-6l6v1OBEPBO4AwudWXoL2w-1; Wed,
 05 Jun 2024 09:42:35 -0400
X-MC-Unique: 6l6v1OBEPBO4AwudWXoL2w-1
Received: from mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.15])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id A8BBC1944D2B;
	Wed,  5 Jun 2024 13:42:34 +0000 (UTC)
Received: from fedora (unknown [10.45.225.116])
	by mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with SMTP id 55E0B1956086;
	Wed,  5 Jun 2024 13:42:32 +0000 (UTC)
Received: by fedora (sSMTP sendmail emulation); Wed, 05 Jun 2024 15:42:31 +0200
From: "Jerome Marchand" <jmarchan@redhat.com>
To: Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Cc: Steven Rostedt <rostedt@goodmis.org>,
	Jerome Marchand <jmarchan@redhat.com>
Subject: [PATCH 26/38] trace-cmd record: don't print a NULL string in get_temp_file()
Date: Wed,  5 Jun 2024 15:40:41 +0200
Message-ID: <20240605134054.2626953-27-jmarchan@redhat.com>
In-Reply-To: <20240605134054.2626953-1-jmarchan@redhat.com>
References: <20240605134054.2626953-1-jmarchan@redhat.com>
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.15

In get_temp_file() if we fails to allocate a temp file for a top
instance, a NULL pointer is passed as the argument for a %s format in
the error message.

Signed-off-by: Jerome Marchand <jmarchan@redhat.com>
---
 tracecmd/trace-record.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tracecmd/trace-record.c b/tracecmd/trace-record.c
index 2223d5bb..b4cbd438 100644
--- a/tracecmd/trace-record.c
+++ b/tracecmd/trace-record.c
@@ -559,7 +559,7 @@ static char *get_temp_file(struct buffer_instance *instance, int cpu)
 		size = snprintf(file, 0, "%s.cpu%d", output_file, cpu);
 		file = malloc(size + 1);
 		if (!file)
-			die("Failed to allocate temp file for %s", name);
+			die("Failed to allocate temp file");
 		sprintf(file, "%s.cpu%d", output_file, cpu);
 	}
 
-- 
2.44.0

