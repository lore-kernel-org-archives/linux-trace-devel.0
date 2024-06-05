Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D30219D88A
	for <linux-trace-devel@vger.kernel.org>; Wed,  5 Jun 2024 13:43:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717594994; cv=none; b=Fxx7MZawVSU5Ecq91ODfMWgOoMf4D0THOfCXVuQZh/wt+egOUEeJ6wlWZLM67aAslgPHFVNtFLwiz/mALBvJMNLvpZp/vNAnF5MWAVAcdA8+NIvSmZrdK+TUuDfDY2pwSJDzdTD+SHrLrpXIFrOPd9imf6YnNr559JOn/U8/yWY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717594994; c=relaxed/simple;
	bh=tnUAQLSunvSeG8aBGa3CGilT35rBrOsf4QGUJfybdo8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EnDk/OWUWBW8NyPKOiY2z8v4B23zCYHFJXIj4uu4PklDSuIRj2tHK8STDgipWejoKw5NQWSzXSVvch7v4UVk8nopGVvxg06Ix48NwDqi0JruD7KKtfW3QuTW2/znZnjDZfZMBHR49k9Jw032pBp5BGGMs5xgmtGEdHBNApJt66c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=I27hCfqc; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="I27hCfqc"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1717594992;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=8be4saJdvBkg6gVYmHyNRCfhIOF9e2QAi0g6dAhTxJA=;
	b=I27hCfqcEqvj4TKIinCetv2uJdhlZFnyHNu/JiPk+yzIvwLL/Z7PO02tKucx8bod7vj1JG
	hCbAw/Il9c3AqRne5kkn+0I2wC46wYQBnTtS9NZNEGawm1+JTIpV/QRreMK/sXuaRAWo8P
	spI9lHzMOt/0mCkd2ZQm9kxG9bN2xF0=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-21-bG6eJtFVMbmIZmCAr3AJ0w-1; Wed, 05 Jun 2024 09:43:10 -0400
X-MC-Unique: bG6eJtFVMbmIZmCAr3AJ0w-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 4792785A588;
	Wed,  5 Jun 2024 13:43:10 +0000 (UTC)
Received: from fedora (unknown [10.45.225.116])
	by smtp.corp.redhat.com (Postfix) with SMTP id 6BF58201EAC2;
	Wed,  5 Jun 2024 13:43:08 +0000 (UTC)
Received: by fedora (sSMTP sendmail emulation); Wed, 05 Jun 2024 15:43:07 +0200
From: "Jerome Marchand" <jmarchan@redhat.com>
To: Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Cc: Steven Rostedt <rostedt@goodmis.org>,
	Jerome Marchand <jmarchan@redhat.com>
Subject: [PATCH 37/38] trace-cmd record: close socket fd before retrying to connect
Date: Wed,  5 Jun 2024 15:40:52 +0200
Message-ID: <20240605134054.2626953-38-jmarchan@redhat.com>
In-Reply-To: <20240605134054.2626953-1-jmarchan@redhat.com>
References: <20240605134054.2626953-1-jmarchan@redhat.com>
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.4

In create_record(), if the client whose conection it just accepted
doesn't match, it tries to call get another connection without
releasing the socket file descriptor.

Close the file descriptor before retrying to connect.

Fixes a RESOURCE_LEAK error (CWE-772)

Signed-off-by: Jerome Marchand <jmarchan@redhat.com>
---
 tracecmd/trace-record.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/tracecmd/trace-record.c b/tracecmd/trace-record.c
index c3118546..0191ef2a 100644
--- a/tracecmd/trace-record.c
+++ b/tracecmd/trace-record.c
@@ -3651,6 +3651,7 @@ static int create_recorder(struct buffer_instance *instance, int cpu,
 				    !trace_net_cmp_connection_fd(fd, instance->host)) {
 					dprint("Client does not match '%s' for cpu:%d\n",
 					       instance->host, cpu);
+					close(fd);
 					goto again;
 				}
 			}
-- 
2.44.0

