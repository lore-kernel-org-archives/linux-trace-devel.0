Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2DCB8188CAD
	for <linux-trace-devel@vger.kernel.org>; Wed,  5 Jun 2024 13:42:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717594941; cv=none; b=AM+o9caKjbAnzJTR+30FZ0EQk+ywEAcwi7Ne3El7RY6GLZ2EsIkpO8GomfvW4/zyD8V9ndZ77rhjfSwTNjJYLgDk7su43T4zrfNivMY3OohNVbcAsvdYgdp44q/OBZNIZ5IDIqGXOXHI/rNTMMgp89sVtBMudKG8fuZIcCPVF3o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717594941; c=relaxed/simple;
	bh=O06QTDqQJ+B8p/Rs65MbqeQtNgmuUu/E6CBAoMDVT2Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=i3XP52lreORQlSa0U9mjlygl/Quf+rQfEk+IqqRimU74cLDu+Y12U5fs7HmIfW1pgxPpMoiqB5Sz/T9MQLwChEWhaPPh3rRJsVYssTmnJl1lVVxjR6ORW6uaKiWLo7FdktX3eyVJYZp1hmK6JE2ocoHU128rjyzEi2DkOk6jHA0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=XUtNtINd; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="XUtNtINd"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1717594939;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=+aAZ1Cwx63dV+UjyEeA4ljlo8JJOVLq7NFEZvbv/7EQ=;
	b=XUtNtINdV+ivVUd9E3rghp6E8bGFmwwK2EAdFiGHuhNuoVCs7gMyozZl8LtYFCdcb+R18x
	Vu/bh875V712GRY5wpD8Ikx9Kkw30Pq4dV9+Gy1nB5TjkDy70vOmy414h3Y1950W+cOD2U
	FngtmryYQGkThtjUD+TLEe83PSVIxOo=
Received: from mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-313-PeVYuAN-MAOfoXROcfq0dg-1; Wed,
 05 Jun 2024 09:42:17 -0400
X-MC-Unique: PeVYuAN-MAOfoXROcfq0dg-1
Received: from mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.40])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 4407D1955D78;
	Wed,  5 Jun 2024 13:42:16 +0000 (UTC)
Received: from fedora (unknown [10.45.225.116])
	by mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with SMTP id BB80B1955EB8;
	Wed,  5 Jun 2024 13:42:13 +0000 (UTC)
Received: by fedora (sSMTP sendmail emulation); Wed, 05 Jun 2024 15:42:12 +0200
From: "Jerome Marchand" <jmarchan@redhat.com>
To: Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Cc: Steven Rostedt <rostedt@goodmis.org>,
	Jerome Marchand <jmarchan@redhat.com>
Subject: [PATCH 21/38] trace-cmd record: prevent memory leak in clear_func_filter()
Date: Wed,  5 Jun 2024 15:40:36 +0200
Message-ID: <20240605134054.2626953-22-jmarchan@redhat.com>
In-Reply-To: <20240605134054.2626953-1-jmarchan@redhat.com>
References: <20240605134054.2626953-1-jmarchan@redhat.com>
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.40

Free buf at the end of the function.

Fixes a RESOURCE_LEAK error (CWE-772)

Signed-off-by: Jerome Marchand <jmarchan@redhat.com>
---
 tracecmd/trace-record.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/tracecmd/trace-record.c b/tracecmd/trace-record.c
index a9e5e64d..2223d5bb 100644
--- a/tracecmd/trace-record.c
+++ b/tracecmd/trace-record.c
@@ -2509,6 +2509,7 @@ static void clear_func_filter(const char *file)
 		filter[len+1] = '\0';
 		write_file(file, filter);
 	}
+	free(buf);
 }
 
 static void update_reset_triggers(void)
-- 
2.44.0

